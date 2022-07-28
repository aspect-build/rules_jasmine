"""Mirror of release info"""

# Run /scripts/mirror_release.sh to produce a new bzl file.
load("v4.3.0/repositories.bzl", v4_3_0 = "npm_repositories")

TOOL_VERSIONS = {
    "v4.3.0": v4_3_0,
}