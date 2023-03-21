"""Provides a simple way to test your rules as an external workspace."""

load("@aspect_rules_jasmine//jasmine:defs.bzl", "jasmine_test")
load("@npm//:defs.bzl", "npm_link_all_packages")

npm_link_all_packages(name = "node_modules")

jasmine_test(
    name = "test",
    args = ["*.spec.js"],
    data = ["test.spec.js"],
    node_modules = "//:node_modules",
)
