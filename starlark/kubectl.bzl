load("//starlark:utils.bzl", "download_binary")

# version=https://dl.k8s.io/release/stable.txt
# https://dl.k8s.io/release/${version}/bin/darwin/arm64/kubectl https://dl.k8s.io/release/${version}/bin/darwin/arm64/kubectl.sha256
# https://dl.k8s.io/release/${version}/bin/darwin/amd64/kubectl https://dl.k8s.io/release/${version}/bin/darwin/amd64/kubectl.sha256
# https://dl.k8s.io/release/${version}/bin/linux/arm64/kubectl https://dl.k8s.io/release/${version}/bin/linux/arm64/kubectl.sha256
# https://dl.k8s.io/release/${version}/bin/linux/amd64/kubectl https://dl.k8s.io/release/${version}/bin/linux/amd64/kubectl.sha256

_binaries = {
    "darwin-arm64": ("https://dl.k8s.io/release/v1.27.2/bin/darwin/arm64/kubectl", "d2b045b1a0804d4c46f646aeb6dcd278202b9da12c773d5e462b1b857d1f37d7"),
    "darwin-amd64": ("https://dl.k8s.io/release/v1.27.2/bin/darwin/amd64/kubectl", "ec954c580e4f50b5a8aa9e29132374ce54390578d6e95f7ad0b5d528cb025f85"),
    "linux-amd64": ("https://dl.k8s.io/release/v1.27.2/bin/linux/amd64/kubectl", "4f38ee903f35b300d3b005a9c6bfb9a46a57f92e89ae602ef9c129b91dc6c5a5"),
    "linux-arm64": ("https://dl.k8s.io/release/v1.27.2/bin/linux/amd64/kubectl", "1b0966692e398efe71fe59f913eaec44ffd4468cc1acd00bf91c29fa8ff8f578"),
}

def kubectl_setup(name = "kubectl_bin", binaries = _binaries, bin = ""):
    if (bin == ""):
        bin = name.replace("_bin", "")
    download_binary(name = name, binaries = binaries, bin = bin)



def _kubectl_impl(ctx):
    command = ""
    args = [ctx.executable._kubectl.short_path] + ctx.args

    ctx.actions.write(
        output = ctx.outputs.test,
        content = " ".join(args),
    )

    return [DefaultInfo(
        executable = ctx.outputs.test,
        runfiles = ctx.runfiles(files = [
            ctx.executable._kubectl,
        ]),
    )]

kubectl = rule(
    implementation = _kubectl_impl,
    attrs = {
        "args": attr.string_list(),
        "_kubectl": attr.label(
            cfg = "host",
            executable = True,
            default = Label("@kubectl_bin//:kubectl_bin"),
        )
    },
    outputs = {"test": "%{name}.sh"},
    test = False,
    executable = True,
)

def kustomize(name):
    kubectl(
        name = name,
        args = ["apply", "-k", "--dry-run=client"]
    )

def kustomize_gitops(name, export_path = "cloud"):
    kubectl(
        name = name,
        args = ["apply", "-k", "--dry-run=client"]
    )