load("//lib:repo_utils.bzl", "download_toolchain_binary")
load('@aspect_bazel_lib//lib/private:repo_utils.bzl', 'repo_utils')

_binaries = {
    "darwin_amd64": ("https://github.com/anchore/grype/releases/download/v0.80.0/grype_0.80.0_darwin_amd64.tar.gz", "c4d64bca02be4ff33dd1470726f827698cae4ec4b231de0a281fcfdb097f8ef4"),
    "darwin_arm64": ("https://github.com/anchore/grype/releases/download/v0.80.0/grype_0.80.0_darwin_arm64.tar.gz", "f7aba1ecc0a75a8cd040f9a2ea31e0bbeab871ec8c5f8870a32170e8eb644ae7"),
    "linux_amd64": ("https://github.com/anchore/grype/releases/download/v0.80.0/grype_0.80.0_linux_amd64.tar.gz", "a86a90074129cb72b47476f6ac3959eab95fba71f095521f5c8e58152463bd24"),
    "linux_arm64": ("https://github.com/anchore/grype/releases/download/v0.80.0/grype_0.80.0_linux_arm64.tar.gz", "430365efd68e0c5a235ab57ed23622240d812e6b15b665f82a259f339136f895"),
}

DEFAULT_GRYPE_VERSION = "0.80.0"
DEFAULT_GRYPE_REPOSITORY = "grype"

GRYPE_PLATFORMS = {
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

GrypeInfo = provider(
    doc = "Provide info for executing grype",
    fields = {
        "bin": "Executable grype binary",
    },
)

def _grype_toolchain_impl(ctx):
    binary = ctx.file.bin

    # Make the $(GRYPE_BIN) variable available in places like genrules.
    # See https://docs.bazel.build/versions/main/be/make-variables.html#custom_variables
    template_variables = platform_common.TemplateVariableInfo({
        "GRYPE_BIN": binary.path,
    })
    default_info = DefaultInfo(
        files = depset([binary]),
        runfiles = ctx.runfiles(files = [binary]),
    )
    grype_info = GrypeInfo(
        bin = binary,
    )

    # Export all the providers inside our ToolchainInfo
    # so the resolved_toolchain rule can grab and re-export them.
    toolchain_info = platform_common.ToolchainInfo(
        grypeinfo = grype_info,
        template_variables = template_variables,
        default = default_info,
    )

    return [default_info, toolchain_info, template_variables]

grype_toolchain = rule(
    implementation = _grype_toolchain_impl,
    attrs = {
        "bin": attr.label(
            mandatory = True,
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
    },
)

def _grype_toolchains_repo_impl(rctx):
    # Expose a concrete toolchain which is the result of Bazel resolving the toolchain
    # for the execution or target platform.
    # Workaround for https://github.com/bazelbuild/bazel/issues/14009
    starlark_content = """# @generated by @rules_k8s_cd//grype_toolchain.bzl

# Forward all the providers
def _resolved_toolchain_impl(ctx):
    toolchain_info = ctx.toolchains["@rules_k8s_cd//lib:grype_toolchain_type"]
    return [
        toolchain_info,
        toolchain_info.default,
        toolchain_info.grypeinfo,
        toolchain_info.template_variables,
    ]

# Copied from java_toolchain_alias
# https://cs.opensource.google/bazel/bazel/+/master:tools/jdk/java_toolchain_alias.bzl
resolved_toolchain = rule(
    implementation = _resolved_toolchain_impl,
    toolchains = ["@rules_k8s_cd//lib:grype_toolchain_type"],
    incompatible_use_toolchain_transition = True,
)
"""
    rctx.file("defs.bzl", starlark_content)

    build_content = """# @generated by @rules_k8s_cd//lib/private:grype_toolchain.bzl
#
# These can be registered in the workspace file or passed to --extra_toolchains flag.
# By default all these toolchains are registered by the grype_register_toolchains macro
# so you don't normally need to interact with these targets.

load(":defs.bzl", "resolved_toolchain")

resolved_toolchain(name = "resolved_toolchain", visibility = ["//visibility:public"])

"""

    for [platform, meta] in GRYPE_PLATFORMS.items():
        build_content += """
toolchain(
    name = "{platform}_toolchain",
    exec_compatible_with = {compatible_with},
    toolchain = "@{user_repository_name}_{platform}//:grype_toolchain",
    toolchain_type = "@rules_k8s_cd//lib:grype_toolchain_type",
)
""".format(
            platform = platform,
            user_repository_name = rctx.attr.user_repository_name,
            compatible_with = meta.compatible_with,
        )

    # Base BUILD file for this repository
    rctx.file("BUILD.bazel", build_content)

grype_toolchains_repo = repository_rule(
    _grype_toolchains_repo_impl,
    doc = """Creates a repository with toolchain definitions for all known platforms
     which can be registered or selected.""",
    attrs = {
        "user_repository_name": attr.string(doc = "Base name for toolchains repository"),
    },
)

def _grype_platform_repo_impl(rctx):
    is_windows = rctx.attr.platform.startswith("windows_")
    meta = GRYPE_PLATFORMS[rctx.attr.platform]
    release_platform = meta.release_platform if hasattr(meta, "release_platform") else rctx.attr.platform
    download_toolchain_binary(
        rctx = rctx,
        toolchain_name = "grype",
        platform = rctx.attr.platform,
        binary = _binaries[rctx.attr.platform],
    )

grype_platform_repo = repository_rule(
    implementation = _grype_platform_repo_impl,
    doc = "Fetch external tools needed for grype toolchain",
    attrs = {
        "platform": attr.string(mandatory = True, values = GRYPE_PLATFORMS.keys()),
    },
)


def _grype_host_alias_repo(rctx):
    ext = ".exe" if repo_utils.is_windows(rctx) else ""

    # Base BUILD file for this repository
    rctx.file("BUILD.bazel", """# @generated by @rules_k8s_cd//lib/private:grype_toolchain.bzl
package(default_visibility = ["//visibility:public"])
exports_files(["grype{ext}"])
""".format(
        ext = ext,
    ))

    rctx.symlink("../{name}_{platform}/grype{ext}".format(
        name = rctx.attr.name,
        platform = repo_utils.platform(rctx),
        ext = ext,
    ), "grype{ext}".format(ext = ext))

grype_host_alias_repo = repository_rule(
    _grype_host_alias_repo,
    doc = """Creates a repository with a shorter name meant for the host platform, which contains
    a BUILD.bazel file that exports symlinks to the host platform's binaries
    """,
)