"""Declare runtime dependencies

These are needed for local dev, and users must install them as well.
See https://docs.bazel.build/versions/main/skylark/deploying.html#dependencies
"""
load("//jasmine/private:versions.bzl", "TOOL_VERSIONS")

LATEST_VERSION = TOOL_VERSIONS.keys()[-1]


_DOC = "Fetch external tools needed for jasmine"
_ATTRS = {
    "jasmine_version": attr.string(mandatory = True, values = TOOL_VERSIONS.keys()),
}

def _jasmine_repo_impl(repository_ctx):
    # Base BUILD file for this repository
    repository_ctx.file("BUILD.bazel", """\
# Generated by @aspect_rules_jasmine//jasmine:repositories.bzl
load("@aspect_rules_jasmine//jasmine/private:{version}/defs.bzl", "npm_link_all_packages")
load("@aspect_bazel_lib//lib:directory_path.bzl", "directory_path")

npm_link_all_packages(name = "node_modules")

directory_path(
    name = "jasmine_entrypoint",
    directory = ":node_modules/jasmine/dir",
    path = "bin/jasmine.js",
    visibility = ["//visibility:public"],
)
""".format(version = repository_ctx.attr.jasmine_version))

    repository_ctx.file("jasmine/BUILD.bazel", "")
    repository_ctx.file("jasmine/defs.bzl", """\
# Generated by @aspect_rules_jasmine//jasmine:repositories.bzl
load("@aspect_rules_jasmine//jasmine:defs.bzl", _jasmine_test = "jasmine_test")

def jasmine_test(**kwargs):
    _jasmine_test(jasmine_repository="{name}", **kwargs)
""".format(name = repository_ctx.attr.name))

jasmine_repository = repository_rule(
    _jasmine_repo_impl,
    doc = _DOC,
    attrs = _ATTRS,
)

# Wrapper macro around everything above, this is the primary API
def rules_jasmine_repositories(name, jasmine_version, **kwargs):
    if jasmine_version not in TOOL_VERSIONS.keys():
        fail("""
jasmine version {} is not currently mirrored into rules_jasmine.
Please instead choose one of these available versions: {}
Or, make a PR to the repo running /scripts/mirror_release.sh to add the newest version.
If you need custom versions, please file an issue.""".format(jasmine_version, TOOL_VERSIONS.keys()))

    TOOL_VERSIONS[jasmine_version]()

    jasmine_repository(
        name = name,
        jasmine_version = jasmine_version
    )
