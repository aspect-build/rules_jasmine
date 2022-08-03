load("@aspect_rules_js//js:libs.bzl", "js_binary_lib", "js_lib_helpers")
load("@bazel_skylib//lib:dicts.bzl", "dicts")   

_attrs = dicts.add(js_binary_lib.attrs, {
    "entry_point": attr.label(
        mandatory = True,
    ),
    "config": attr.label(
        doc = "jasmine config file. See: https://jasmine.github.io/setup/nodejs.html#configuration",
        allow_single_file = [".json", ".js"]
    )
})


def _impl(ctx):

    files = js_lib_helpers.gather_files_from_js_providers(
        targets = ctx.attr.data,
        include_transitive_sources = ctx.attr.include_transitive_sources,
        include_declarations = ctx.attr.include_declarations,
        include_npm_linked_packages = ctx.attr.include_npm_linked_packages,
    )
    files.extend(ctx.files.data)

    fixed_args = [
        "*.spec.*js",
        "*.test.*js"
    ]

    if ctx.attr.config:
        fixed_args.append(
            "--config",
            ctx.file.config.short_path,
        )
        files.append(ctx.file.config)

    launcher = js_binary_lib.create_launcher(
        ctx,
        log_prefix_rule_set = "aspect_rules_jasmine",
        log_prefix_rule = "jasmine_node_test",
        fixed_args = fixed_args,
    )

    runfiles = ctx.runfiles(
        files = files,
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