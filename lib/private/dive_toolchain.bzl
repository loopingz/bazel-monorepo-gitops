load("//lib:repo_utils.bzl", "download_toolchain_binary")
load('@aspect_bazel_lib//lib/private:repo_utils.bzl', 'repo_utils')

_binaries = {
    "darwin_amd64": ("https://github.com/wagoodman/dive/releases/download/v0.12.0/dive_0.12.0_darwin_amd64.tar.gz", "2f7d0a7f970e09618b87f286c6ccae6a7423331372c6ced15760a5c9d6f27704"),
    "darwin_arm64": ("https://github.com/wagoodman/dive/releases/download/v0.12.0/dive_0.12.0_darwin_arm64.tar.gz", "8ead7ce468f230ffce45b679dd1421945d6e4276654b0d90d389e357af2f4151"),
    "linux_amd64": ("https://github.com/wagoodman/dive/releases/download/v0.12.0/dive_0.12.0_linux_amd64.tar.gz", "20a7966523a0905f950c4fbf26471734420d6788cfffcd4a8c4bc972fded3e96"),
    "linux_arm64": ("https://github.com/wagoodman/dive/releases/download/v0.12.0/dive_0.12.0_linux_arm64.tar.gz", "a2a1470302cdfa367a48f80b67bbf11c0cd8039af9211e39515bd2bbbda58fea"),
}

DEFAULT_DIVE_VERSION = "0.12.0"
DEFAULT_DIVE_REPOSITORY = "dive"

DIVE_PLATFORMS = {
    "darwin_amd64": struct(
        release_platform = "macos-amd64",
        compatible_with = [
            "@platforms//os:macos",
            "@platforms//cpu:x86_64",
        ],
    ),
    "darwin_arm64": struct(
        release_platform = "macos-arm64",
        compatible_with = [
            "@platforms//os:macos",
            "@platforms//cpu:aarch64",
        ],
    ),
    "linux_amd64": struct(
        release_platform = "linux-amd64",
        compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
    ),
    "linux_arm64": struct(
        release_platform = "linux-arm64",
        compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:aarch64",
        ],
    ),
}

DiveInfo = provider(
    doc = "Provide info for executing dive",
    fields = {
        "bin": "Executable dive binary",
    },
)

def _dive_toolchain_impl(ctx):
    binary = ctx.file.bin

    # Make the $(DIVE_BIN) variable available in places like genrules.
    # See https://docs.bazel.build/versions/main/be/make-variables.html#custom_variables
    template_variables = platform_common.TemplateVariableInfo({
        "DIVE_BIN": binary.path,
    })
    default_info = DefaultInfo(
        files = depset([binary]),
        runfiles = ctx.runfiles(files = [binary]),
    )
    dive_info = DiveInfo(
        bin = binary,
    )

    # Export all the providers inside our ToolchainInfo
    # so the resolved_toolchain rule can grab and re-export them.
    toolchain_info = platform_common.ToolchainInfo(
        diveinfo = dive_info,
        template_variables = template_variables,
        default = default_info,
    )

    return [default_info, toolchain_info, template_variables]

dive_toolchain = rule(
    implementation = _dive_toolchain_impl,
    attrs = {
        "bin": attr.label(
            mandatory = True,
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
    },
)

def _dive_toolchains_repo_impl(rctx):
    # Expose a concrete toolchain which is the result of Bazel resolving the toolchain
    # for the execution or target platform.
    # Workaround for https://github.com/bazelbuild/bazel/issues/14009
    starlark_content = """# @generated by @rules_k8s_cd//dive_toolchain.bzl

# Forward all the providers
def _resolved_toolchain_impl(ctx):
    toolchain_info = ctx.toolchains["@rules_k8s_cd//lib:dive_toolchain_type"]
    return [
        toolchain_info,
        toolchain_info.default,
        toolchain_info.diveinfo,
        toolchain_info.template_variables,
    ]

# Copied from java_toolchain_alias
# https://cs.opensource.google/bazel/bazel/+/master:tools/jdk/java_toolchain_alias.bzl
resolved_toolchain = rule(
    implementation = _resolved_toolchain_impl,
    toolchains = ["@rules_k8s_cd//lib:dive_toolchain_type"],
    incompatible_use_toolchain_transition = True,
)
"""
    rctx.file("defs.bzl", starlark_content)

    build_content = """# @generated by @rules_k8s_cd//lib/private:dive_toolchain.bzl
#
# These can be registered in the workspace file or passed to --extra_toolchains flag.
# By default all these toolchains are registered by the dive_register_toolchains macro
# so you don't normally need to interact with these targets.

load(":defs.bzl", "resolved_toolchain")

resolved_toolchain(name = "resolved_toolchain", visibility = ["//visibility:public"])

"""

    for [platform, meta] in DIVE_PLATFORMS.items():
        build_content += """
toolchain(
    name = "{platform}_toolchain",
    exec_compatible_with = {compatible_with},
    toolchain = "@{user_repository_name}_{platform}//:dive_toolchain",
    toolchain_type = "@rules_k8s_cd//lib:dive_toolchain_type",
)
""".format(
            platform = platform,
            user_repository_name = rctx.attr.user_repository_name,
            compatible_with = meta.compatible_with,
        )

    # Base BUILD file for this repository
    rctx.file("BUILD.bazel", build_content)

dive_toolchains_repo = repository_rule(
    _dive_toolchains_repo_impl,
    doc = """Creates a repository with toolchain definitions for all known platforms
     which can be registered or selected.""",
    attrs = {
        "user_repository_name": attr.string(doc = "Base name for toolchains repository"),
    },
)

def _dive_platform_repo_impl(rctx):
    is_windows = rctx.attr.platform.startswith("windows_")
    meta = DIVE_PLATFORMS[rctx.attr.platform]
    release_platform = meta.release_platform if hasattr(meta, "release_platform") else rctx.attr.platform
    download_toolchain_binary(
        rctx = rctx,
        toolchain_name = "dive",
        platform = rctx.attr.platform,
        binary = _binaries[rctx.attr.platform],
    )

dive_platform_repo = repository_rule(
    implementation = _dive_platform_repo_impl,
    doc = "Fetch external tools needed for dive toolchain",
    attrs = {
        "platform": attr.string(mandatory = True, values = DIVE_PLATFORMS.keys()),
    },
)


def _dive_host_alias_repo(rctx):
    ext = ".exe" if repo_utils.is_windows(rctx) else ""

    # Base BUILD file for this repository
    rctx.file("BUILD.bazel", """# @generated by @rules_k8s_cd//lib/private:dive_toolchain.bzl
package(default_visibility = ["//visibility:public"])
print("HOST_ALIAS DIVE")
exports_files(["dive{ext}"])
""".format(
        ext = ext,
    ))

    rctx.symlink("../{name}_{platform}/dive{ext}".format(
        name = rctx.attr.name,
        platform = repo_utils.platform(rctx),
        ext = ext,
    ), "dive{ext}".format(ext = ext))

dive_host_alias_repo = repository_rule(
    _dive_host_alias_repo,
    doc = """Creates a repository with a shorter name meant for the host platform, which contains
    a BUILD.bazel file that exports symlinks to the host platform's binaries
    """,
)