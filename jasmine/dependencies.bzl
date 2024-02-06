"""Declare runtime dependencies

These are needed for local dev, and users must install them as well.
See https://docs.bazel.build/versions/main/skylark/deploying.html#dependencies
"""

load("//jasmine/private:maybe.bzl", http_archive = "maybe_http_archive")

# buildifier: disable=function-docstring
def rules_jasmine_dependencies():
    http_archive(
        name = "bazel_skylib",
        sha256 = "cd55a062e763b9349921f0f5db8c3933288dc8ba4f76dd9416aac68acee3cb94",
        urls = ["https://github.com/bazelbuild/bazel-skylib/releases/download/1.5.0/bazel-skylib-1.5.0.tar.gz"],
    )

    http_archive(
        name = "aspect_bazel_lib",
        sha256 = "04feedcd06f71d0497a81fdd3220140a373ff9d2bff94620fbd50b774f96d8e0",
        strip_prefix = "bazel-lib-1.40.2",
        url = "https://github.com/aspect-build/bazel-lib/releases/download/v1.40.2/bazel-lib-v1.40.2.tar.gz",
    )

    http_archive(
        name = "aspect_rules_js",
        sha256 = "630a71aba66c4023a5b16ab3efafaeed8b1a2865ccd168a34611eb73876b3fc4",
        strip_prefix = "rules_js-1.37.1",
        url = "https://github.com/aspect-build/rules_js/releases/download/v1.37.1/rules_js-v1.37.1.tar.gz",
    )

    http_archive(
        name = "rules_nodejs",
        sha256 = "8fc8e300cb67b89ceebd5b8ba6896ff273c84f6099fc88d23f24e7102319d8fd",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/5.8.4/rules_nodejs-core-5.8.4.tar.gz"],
    )

    http_archive(
        name = "bazel_features",
        sha256 = "0f23d75c7623d6dba1fd30513a94860447de87c8824570521fcc966eda3151c2",
        strip_prefix = "bazel_features-1.4.1",
        url = "https://github.com/bazel-contrib/bazel_features/releases/download/v1.4.1/bazel_features-v1.4.1.tar.gz",
    )
