"""Our "development" dependencies

Users should *not* need to install these. If users see a load()
statement from these, that's a bug in our distribution.
"""

# buildifier: disable=bzl-visibility
load("//jasmine/private:maybe.bzl", http_archive = "maybe_http_archive")

def rules_jasmine_internal_deps():
    "Fetch deps needed for local development"
    http_archive(
        name = "io_bazel_stardoc",
        sha256 = "62bd2e60216b7a6fec3ac79341aa201e0956477e7c8f6ccc286f279ad1d96432",
        urls = ["https://github.com/bazelbuild/stardoc/releases/download/0.6.2/stardoc-0.6.2.tar.gz"],
    )

    http_archive(
        name = "buildifier_prebuilt",
        sha256 = "8ada9d88e51ebf5a1fdff37d75ed41d51f5e677cdbeafb0a22dda54747d6e07e",
        strip_prefix = "buildifier-prebuilt-6.4.0",
        urls = ["http://github.com/keith/buildifier-prebuilt/archive/6.4.0.tar.gz"],
    )

    http_archive(
        name = "aspect_rules_lint",
        sha256 = "98bed74aff6498ea9b58ff36db27a952c7a1b53764171c5d0d29ef0c61ffc4fb",
        strip_prefix = "rules_lint-0.11.0",
        url = "https://github.com/aspect-build/rules_lint/releases/download/v0.11.0/rules_lint-v0.11.0.tar.gz",
    )
