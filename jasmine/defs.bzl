"rules_jasmine public API"

load("@aspect_bazel_lib//lib:copy_file.bzl", "copy_file")
load("@aspect_bazel_lib//lib:utils.bzl", "default_timeout")
load("@aspect_rules_jasmine//jasmine/private:jasmine_test.bzl", _jasmine_test = "jasmine_test")

jasmine_test_rule = _jasmine_test

def jasmine_test(
        name,
        node_modules,
        jasmine_reporters = True,
        config = None,
        timeout = None,
        size = None,
        data = [],
        **kwargs):
    """Runs jasmine under `bazel test`

    Args:
        name: A unique name for this target.

        node_modules: Label pointing to the linked node_modules target where jasmine is linked, e.g. `//:node_modules`.

            `jasmine` must be linked into the node_modules supplied.
            `jasmine-reporters` is also required by default when jasmine_reporters is True
            `jasmine-core` is required when using sharding.

        jasmine_reporters: Whether `jasmine-reporters` is present in the supplied node_modules tree.

            When enabled, adds a custom reporter to output junit XML to the path where Bazel expects to find it.

        config: jasmine config file. See: https://jasmine.github.io/setup/nodejs.html#configuration

        timeout: standard attribute for tests. Defaults to "short" if both timeout and size are unspecified.

        size: standard attribute for tests

        data: Runtime dependencies that Jasmine should be able to read.

            This should include all test files, configuration files & files under test.

        **kwargs: Additional named parameters from `js_test`.
            See [js_test docs](https://github.com/aspect-build/rules_js/blob/main/docs/js_binary.md#js_test)
    """
    entry_point = "_{}_jasmine_runner.cjs".format(name)
    copy_file(
        name = "_{}_copy_jasmine_runner".format(name),
        src = "@aspect_rules_jasmine//jasmine/private:runner.cjs",
        out = entry_point,
    )

    data = data + ["{}/jasmine".format(node_modules)]

    junit_reporter = None
    if jasmine_reporters:
        junit_reporter = "_{}_jasmine_junit_reporter.cjs".format(name)
        copy_file(
            name = "_{}_copy_jasmine_junit_reporter".format(name),
            src = "@aspect_rules_jasmine//jasmine/private:junit_reporter.cjs",
            out = junit_reporter,
        )
        data.append("{}/jasmine-reporters".format(node_modules))

    if kwargs.get("shard_count", None):
        data.append("{}/jasmine-core".format(node_modules))

    jasmine_test_rule(
        name = name,
        config = config,
        enable_runfiles = select({
            "@aspect_bazel_lib//lib:enable_runfiles": True,
            "//conditions:default": False,
        }),
        entry_point = entry_point,
        junit_reporter = junit_reporter,
        data = data,
        size = size,
        timeout = default_timeout(size, timeout),
        **kwargs
    )
