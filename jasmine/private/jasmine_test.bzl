"jasmine_test rule."

load("@aspect_rules_js//js:libs.bzl", "js_binary_lib", "js_lib_helpers")
load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@bazel_skylib//lib:paths.bzl", "paths")

_attrs = dicts.add(js_binary_lib.attrs, {
    "junit_reporter": attr.label(
        allow_single_file = True,
    ),
    "config": attr.label(
        allow_single_file = [".json", ".js"],
    ),
})

def _impl(ctx):
    files = ctx.files.data[:]

    fixed_args = []
    fixed_args.extend(ctx.attr.fixed_args)

    if ctx.attr.junit_reporter:
        files.append(ctx.file.junit_reporter)

        junit_reporter = ctx.file.junit_reporter.short_path
        if ctx.attr.chdir:
            junit_reporter = "/".join([".." for _ in ctx.attr.chdir.split("/")] + [junit_reporter])

        fixed_args.append("--require=file://../%s" % junit_reporter)

    if ctx.attr.config:
        config_file = ctx.file.config.short_path
        if ctx.attr.chdir:
            config_file = paths.relativize(ctx.file.config.short_path, ctx.attr.chdir)
        fixed_args.append("--config=%s" % config_file)
        files.append(ctx.file.config)

    launcher = js_binary_lib.create_launcher(
        ctx,
        log_prefix_rule_set = "aspect_rules_jasmine",
        log_prefix_rule = "jasmine_node_test",
        fixed_args = fixed_args,
    )

    runfiles = ctx.runfiles(
        files = files,
        transitive_files = js_lib_helpers.gather_files_from_js_infos(
            targets = ctx.attr.data,
            include_sources = ctx.attr.include_sources,
            include_types = ctx.attr.include_types,
            include_transitive_sources = ctx.attr.include_transitive_sources,
            include_transitive_types = ctx.attr.include_transitive_types,
            include_npm_sources = ctx.attr.include_npm_sources,
        ),
    ).merge(launcher.runfiles).merge_all([
        target[DefaultInfo].default_runfiles
        for target in ctx.attr.data
    ])

    return [
        DefaultInfo(
            executable = launcher.executable,
            runfiles = runfiles,
        ),
    ]

# Expose a lib so others can build their own rule.
lib = struct(
    attrs = _attrs,
    implementation = _impl,
)

jasmine_test = rule(
    doc = """Runs tests in NodeJS using the Jasmine test runner.""",
    attrs = lib.attrs,
    implementation = lib.implementation,
    test = True,
    toolchains = js_binary_lib.toolchains,
)
