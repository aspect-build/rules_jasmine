"rules_jasmine test helpers"

load("@aspect_bazel_lib//lib:testing.bzl", "assert_contains")
load("//jasmine:defs.bzl", "jasmine_test")

def generate_jasmine_tests():
    """Generates a standard set of jasmine_test targets.
    """
    jasmine_test(
        name = "junit_reporter",
        args = [
            "**/*.test.js",
        ],
        data = ["//jasmine/tests:junit_reporter.test"],
        node_modules = ":node_modules",
    )

    jasmine_test(
        name = "focused",
        args = [
            "**/*.test.js",
        ],
        data = ["//jasmine/tests:focused.test"],
        expected_exit_code = 2,
        node_modules = ":node_modules",
    )

    jasmine_test(
        name = "exclusions",
        args = [
            "**/*.test.js",
        ],
        data = ["//jasmine/tests:exclusions.test"],
        node_modules = ":node_modules",
    )

    jasmine_test(
        name = "config",
        config = "//jasmine/tests:config_file",
        data = ["//jasmine/tests:config_file.test", "//jasmine/tests:config_file"],
        node_modules = ":node_modules",
    )

    jasmine_test(
        name = "stack",
        args = [
            "**/*.test.js",
        ],
        data = ["//jasmine/tests:stack.test"],
        node_modules = ":node_modules",
    )

    jasmine_test(
        name = "shard",
        args = [
            "**/*.test.js",
            "--random=false",
        ],
        data = ["//jasmine/tests:shard.test"],
        node_modules = ":node_modules",
        shard_count = 3,
    )

    # Verify that the error code is propogated out from a failing spec
    jasmine_test(
        name = "failing",
        args = [
            "**/*.test.js",
            "--random=false",
        ],
        data = ["//jasmine/tests:failing.test"],
        expected_exit_code = 3,
        node_modules = ":node_modules",
    )

    jasmine_test(
        name = "failing_shard",
        args = [
            "**/*.test.js",
            "--random=false",
        ],
        data = ["//jasmine/tests:failing.test"],
        expected_exit_code = 3,
        node_modules = ":node_modules",
        shard_count = 2,
    )

    jasmine_test(
        name = "esm",
        args = [
            "**/*.test.mjs",
            "--random=false",
        ],
        data = ["//jasmine/tests:esm.test"],
        node_modules = ":node_modules",
    )

    jasmine_test(
        name = "cjs",
        args = [
            "**/*.test.cjs",
            "--random=false",
        ],
        data = ["//jasmine/tests:cjs.test"],
        node_modules = ":node_modules",
    )

    jasmine_test(
        name = "fixed_args",
        args = ["**/*.test.js"],
        data = ["//jasmine/tests:fixed_args.test"],
        fixed_args = ["--random=true"],
        node_modules = ":node_modules",
    )

    # assert that the bash launcher script contains the fixed arg --random=true
    assert_contains(
        name = "fixed_args_bash_launcher_test",
        actual = ":fixed_args",
        expected = "--random=true",
        target_compatible_with = select({
            # this test asserts the contents of the bash launcher so is disabled on Windows
            # since on Windows the default output of `:test` is the `.bat` wrapper
            "@platforms//os:windows": ["@platforms//:incompatible"],
            "//conditions:default": [],
        }),
    )
