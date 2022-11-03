"Public API re-exports"

load("@aspect_rules_jasmine//jasmine/private:jasmine_test.bzl", "lib")
load("@aspect_rules_js//js:libs.bzl", "js_binary_lib")

_jasmine_test = rule(
    doc = """Runs tests in NodeJS using the Jasmine test runner.""",
    attrs = lib.attrs,
    implementation = lib.implementation,
    test = True,
    toolchains = js_binary_lib.toolchains,
)

def jasmine_test(jasmine_repository = "jasmine", **kwargs):
    _jasmine_test(
        enable_runfiles = select({
            "@aspect_rules_js//js/private:enable_runfiles": True,
            "//conditions:default": False,
        }),
        entry_point = "@{}//:jasmine_entrypoint".format(jasmine_repository),
        junit_reporter = "@{}//:junit_reporter".format(jasmine_repository),
        data = kwargs.pop("data", []) + [
            "@{}//:node_modules/jasmine".format(jasmine_repository),
            "@{}//:node_modules/jasmine-core".format(jasmine_repository),
            "@{}//:node_modules/jasmine-reporters".format(jasmine_repository),
        ],
        **kwargs
    )
