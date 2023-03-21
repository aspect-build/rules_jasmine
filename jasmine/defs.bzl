"Public API re-exports"

load("@aspect_bazel_lib//lib:copy_file.bzl", "copy_file")
load("@aspect_rules_jasmine//jasmine/private:jasmine_test.bzl", "lib")
load("@aspect_rules_js//js:libs.bzl", "js_binary_lib")

_jasmine_test = rule(
    doc = """Runs tests in NodeJS using the Jasmine test runner.""",
    attrs = lib.attrs,
    implementation = lib.implementation,
    test = True,
    toolchains = js_binary_lib.toolchains,
)

def jasmine_test(
        name,
        node_modules,
        generate_junit_xml = True,
        config = None,
        **kwargs):
    """jasmine_test rule

    Args:
        name: A unique name for this target.

        node_modules: Label pointing to the linked node_modules target where jasmine is linked, e.g. `//:node_modules`.

            `jasmine` must be linked into the node_modules supplied.
            `jasmine-reporters` is also required by default when generate_junit_xml is True
            `jasmine-core` is required when using sharding.

        generate_junit_xml: Add a custom reporter to output junit XML to `process.env.XML_OUTPUT_FILE` where Bazel expects to find it.

            When enabled, `jasmine-reporters` must be linked to the supplied node_modules tree.

        config: jasmine config file. See: https://jasmine.github.io/setup/nodejs.html#configuration

        **kwargs: All other args from `js_test`. See https://github.com/aspect-build/rules_js/blob/main/docs/js_binary.md#js_test
    """
    entry_point = "_{}_jasmine_runner.cjs".format(name)
    copy_file(
        name = "_{}_copy_jasmine_runner".format(name),
        src = "@aspect_rules_jasmine//jasmine/private:runner.cjs",
        out = entry_point,
    )

    data = kwargs.pop("data", []) + ["{}/jasmine".format(node_modules)]

    junit_reporter = None
    if generate_junit_xml:
        junit_reporter = "_{}_jasmine_junit_reporter.cjs".format(name)
        copy_file(
            name = "_{}_copy_jasmine_junit_reporter".format(name),
            src = "@aspect_rules_jasmine//jasmine/private:junit_reporter.cjs",
            out = junit_reporter,
        )
        data.append("{}/jasmine-reporters".format(node_modules))

    if kwargs.get("shard_count", None):
        data.append("{}/jasmine-core".format(node_modules))

    _jasmine_test(
        name = name,
        config = config,
        enable_runfiles = select({
            "@aspect_rules_js//js/private:enable_runfiles": True,
            "//conditions:default": False,
        }),
        entry_point = entry_point,
        junit_reporter = junit_reporter,
        data = data,
        **kwargs
    )
