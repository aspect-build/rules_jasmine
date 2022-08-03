"""Provides a simple way to test your rules as an external workspace."""
load("@aspect_rules_js//js:defs.bzl", "js_run_binary")
load("@aspect_bazel_lib//lib:diff_test.bzl", "diff_test")
load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@aspect_rules_jasmine//jasmine:repositories.bzl", "LATEST_VERSION")

js_run_binary(
    name = "ver",
    stdout = "out.txt",
    args = ["-v"],
    tool = "@jasmine//:jasmine"
)


write_file(
    name = "ver_gen",
    out = "out.expected.txt",
    content = [
        "jasmine %s" % LATEST_VERSION,
        "jasmine-core %s" % LATEST_VERSION,
        ""
    ],
)

diff_test(
    name = "test1",
    file1 = "out.txt",
    file2 = "out.expected.txt",
)