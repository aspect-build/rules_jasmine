load("@aspect_rules_js//js:libs.bzl", "js_binary_lib", "js_lib_helpers")
load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@bazel_skylib//lib:paths.bzl", "paths")

_attrs = dicts.add(js_binary_lib.attrs, {
    "junit_reporter": attr.label(
        mandatory = True,
        allow_single_file = True,
    ),
    "config": attr.label(
        doc = "jasmine config file. See: https://jasmine.github.io/setup/nodejs.html#configuration",
        allow_single_file = [".json", ".js"],
    ),
})

def _impl(ctx):
    files = ctx.files.data[:]
    files.append(ctx.file.junit_reporter)

    junit_reporter = ctx.file.junit_reporter.short_path

    if ctx.attr.chdir:
        junit_reporter = "/".join([".." for _ in ctx.attr.chdir.split("/")] + [junit_reporter])

    fixed_args = [
        "--require=file://../%s" % junit_reporter,
    ]

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
        transitive_files = js_lib_helpers.gather_files_from_js_providers(
            targets = ctx.attr.data,
            include_transitive_sources = ctx.attr.include_transitive_sources,
            include_declarations = ctx.attr.include_declarations,
            include_npm_linked_packages = ctx.attr.include_npm_linked_packages,
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

lib = struct(
    attrs = _attrs,
    implementation = _impl,
)
