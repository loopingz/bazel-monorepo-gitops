load("//starlark:utils.bzl", "download_binary", "write_source_files")

# version=https://dl.k8s.io/release/stable.txt
# https://dl.k8s.io/release/${version}/bin/darwin/arm64/kubectl https://dl.k8s.io/release/${version}/bin/darwin/arm64/kubectl.sha256
# https://dl.k8s.io/release/${version}/bin/darwin/amd64/kubectl https://dl.k8s.io/release/${version}/bin/darwin/amd64/kubectl.sha256
# https://dl.k8s.io/release/${version}/bin/linux/arm64/kubectl https://dl.k8s.io/release/${version}/bin/linux/arm64/kubectl.sha256
# https://dl.k8s.io/release/${version}/bin/linux/amd64/kubectl https://dl.k8s.io/release/${version}/bin/linux/amd64/kubectl.sha256

_binaries = {
    "darwin_arm64": ("https://dl.k8s.io/release/v1.27.2/bin/darwin/arm64/kubectl", "d2b045b1a0804d4c46f646aeb6dcd278202b9da12c773d5e462b1b857d1f37d7"),
    "darwin_amd64": ("https://dl.k8s.io/release/v1.27.2/bin/darwin/amd64/kubectl", "ec954c580e4f50b5a8aa9e29132374ce54390578d6e95f7ad0b5d528cb025f85"),
    "linux_amd64": ("https://dl.k8s.io/release/v1.27.2/bin/linux/amd64/kubectl", "4f38ee903f35b300d3b005a9c6bfb9a46a57f92e89ae602ef9c129b91dc6c5a5"),
    "linux_arm64": ("https://dl.k8s.io/release/v1.27.2/bin/linux/amd64/kubectl", "1b0966692e398efe71fe59f913eaec44ffd4468cc1acd00bf91c29fa8ff8f578"),
}

def kubectl_setup(name = "kubectl_bin", binaries = _binaries, bin = ""):
    if (bin == ""):
        bin = name.replace("_bin", "")
    download_binary(name = name, binaries = binaries, bin = bin)



def _kubectl_impl(ctx):
    command = ""
    args = [ctx.executable._kubectl.short_path] + ctx.attr.arguments
    command = " ".join(args)

    ctx.actions.write(
        output = ctx.outputs.launch,
        content = command,
        is_executable = True,
    )

    return [DefaultInfo(
        executable = ctx.outputs.launch,
        runfiles = ctx.runfiles(files = [
            ctx.executable._kubectl,
        ])
    )]

kubectl = rule(
    implementation = _kubectl_impl,
    attrs = {
        "arguments": attr.string_list(),
        "context": attr.label_list(),
        "_kubectl": attr.label(
            cfg = "host",
            executable = True,
            default = Label("@kubectl_bin//:kubectl_bin"),
        )
    },
    outputs = {"launch": "%{name}.sh"},
    test = False,
    executable = True,
)


def _kubectl_export_impl(ctx):

    launch = ctx.actions.declare_file(ctx.attr.name + ".sh")
    args = [ctx.executable._kubectl.path] + ctx.attr.arguments
    # Export target name
    paths = ctx.build_file_path.split("/")
    paths.pop()
    command = "echo '# Generated from bazel build //%s' > %s\n" % ("/".join(paths) + ":" + ctx.attr.name, ctx.outputs.template.path)
    command += " ".join(args)

    command += " >> %s" % (ctx.outputs.template.path)

    ctx.actions.write(
        output = launch,
        content = command,
        is_executable = True,
    )
    inputs = []
    for f in ctx.attr.context:
        inputs = inputs + f.files.to_list() 
    ctx.actions.run(
        executable = launch,
        outputs = [ctx.outputs.template],
        inputs = inputs,
        tools = [ctx.executable._kubectl],
    )

kubectl_export = rule(
    implementation = _kubectl_export_impl,
    attrs = {
        "arguments": attr.string_list(),
        "template": attr.output(),
        "context": attr.label_list(),
        "_kubectl": attr.label(
            cfg = "host",
            executable = True,
            default = Label("@kubectl_bin//:kubectl_bin"),
        )
    },
    test = False,
    executable = False,
)

def kustomize(name, context = []):
    kubectl_export(
        name = name,
        arguments = ["kustomize", "--load-restrictor", "LoadRestrictionsNone", "./deployments/website/"],
        context = context,
        template = "test.yaml",
    )

def kustomize_gitops(name, context = [], export_path = "cloud/{CLUSTER}/{NAMESPACE}/"):
    kustomize(
        name = name + ".kustomize",
        context = context,
    )
    write_source_files(
        name = name,
        srcs = [":" + name + ".kustomize"],
        target = export_path.format(CLUSTER="loopkube", NAMESPACE="bazel-test"),
        strip_prefixes = ["deployments/"]
    )