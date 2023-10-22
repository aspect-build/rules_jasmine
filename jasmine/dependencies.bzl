"""Declare runtime dependencies

These are needed for local dev, and users must install them as well.
See https://docs.bazel.build/versions/main/skylark/deploying.html#dependencies
"""

load("//jasmine/private:maybe.bzl", http_archive = "maybe_http_archive")

def rules_jasmine_dependencies():
    http_archive(
        name = "bazel_skylib",
        sha256 = "74d544d96f4a5bb630d465ca8bbcfe231e3594e5aae57e1edbf17a6eb3ca2506",
        urls = ["https://github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz"],
    )

    http_archive(
        name = "aspect_bazel_lib",
        sha256 = "a185ccff9c1b8589c63f66d7eb908de15c5d6bb05562be5f46336c53e7a7326a",
        strip_prefix = "bazel-lib-2.0.0-rc1",
        url = "https://github.com/aspect-build/bazel-lib/releases/download/v2.0.0-rc1/bazel-lib-v2.0.0-rc1.tar.gz",
    )

    http_archive(
        name = "aspect_rules_js",
        sha256 = "a949d56fed8fa0a8dd82a0a660acc949253a05b2b0c52a07e4034e27f11218f6",
        strip_prefix = "rules_js-1.33.1",
        url = "https://github.com/aspect-build/rules_js/releases/download/v1.33.1/rules_js-v1.33.1.tar.gz",
    )

    http_archive(
        name = "rules_nodejs",
        sha256 = "08337d4fffc78f7fe648a93be12ea2fc4e8eb9795a4e6aa48595b66b34555626",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/5.8.0/rules_nodejs-core-5.8.0.tar.gz"],
    )
