"""Provides a simple way to test your rules as an external workspace."""
load("@jasmine//jasmine:defs.bzl", "jasmine_test")

jasmine_test(
    name = "test",
    data = ["test.spec.js"],
    args = ["*.spec.js"],
)
