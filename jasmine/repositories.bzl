"""Declare runtime dependencies

These are needed for local dev, and users must install them as well.
See https://docs.bazel.build/versions/main/skylark/deploying.html#dependencies
"""

load("//jasmine/private:versions.bzl", "TOOL_VERSIONS")
load("@aspect_rules_js//npm:npm_import.bzl", _npm_translate_lock = "npm_translate_lock")

LATEST_VERSION = TOOL_VERSIONS[0]

def jasmine_repositories(name, jasmine_version = LATEST_VERSION):
    """
    Fetch external tools needed for jasmine

    Args:
        name: Unique name for this jasmine tools repository
        jasmine_version: The jasmine version to fetch.

            See /jasmine/private/versions.bzl for available versions.
    """
    if jasmine_version not in TOOL_VERSIONS:
        fail("""
jasmine version {} is not currently mirrored into rules_jasmine.
Please instead choose one of these available versions: {}
Or, make a PR to the repo running /scripts/mirror_release.sh to add the newest version.
If you need custom versions, please file an issue.""".format(jasmine_version, TOOL_VERSIONS))

    _npm_translate_lock(
        name = name,
        pnpm_lock = "@aspect_rules_jasmine//jasmine/private:{version}/pnpm-lock.yaml".format(version = jasmine_version),
        public_hoist_packages = {
            "jasmine-core": [""],
        },
        # We'll be linking in the @foo repository and not the repository where the pnpm-lock file is located
        link_workspace = name,
        # Override the Bazel package where pnpm-lock.yaml is located and link to the specified package instead
        root_package = "",
        defs_bzl_filename = "npm_link_all_packages.bzl",
        repositories_bzl_filename = "npm_repositories.bzl",
        additional_file_contents = {
            "BUILD.bazel": [
                """load("@aspect_bazel_lib//lib:copy_file.bzl", "copy_file")""",
                """load("//:npm_link_all_packages.bzl", "npm_link_all_packages")""",
                """npm_link_all_packages(name = "node_modules")""",
                """copy_file(
    name = "jasmine_entrypoint",
    src = "@aspect_rules_jasmine//jasmine/private:runner.js",
    out = "runner.js",
    visibility = ["//visibility:public"],
)""",
                """copy_file(
    name = "junit_reporter",
    src = "@aspect_rules_jasmine//jasmine/private:junit_reporter.js",
    out = "junit_reporter.js",
    visibility = ["//visibility:public"],
)""",
                """copy_file(
    name = "package_json",
    src = "@aspect_rules_jasmine//jasmine/private:package.json",
    out = "package.json",
    visibility = ["//visibility:public"],
)""",
            ],
            "defs.bzl": [
                """load("@aspect_rules_jasmine//jasmine:defs.bzl", _jasmine_test = "jasmine_test")""",
                """def jasmine_test(**kwargs):
    _jasmine_test(jasmine_repository="{name}", **kwargs)""".format(name = name),
            ],
        },
    )
