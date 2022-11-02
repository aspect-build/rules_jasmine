"""Provides a simple way to test your rules as an external workspace."""

load("@jasmine//:defs.bzl", "jasmine_test")

jasmine_test(
    name = "test",
    args = ["*.spec.js"],
    data = ["test.spec.js"],
)
