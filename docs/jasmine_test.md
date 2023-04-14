<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public API re-exports

<a id="jasmine_test_rule"></a>

## jasmine_test_rule

<pre>
jasmine_test_rule(<a href="#jasmine_test_rule-name">name</a>, <a href="#jasmine_test_rule-chdir">chdir</a>, <a href="#jasmine_test_rule-config">config</a>, <a href="#jasmine_test_rule-copy_data_to_bin">copy_data_to_bin</a>, <a href="#jasmine_test_rule-data">data</a>, <a href="#jasmine_test_rule-enable_runfiles">enable_runfiles</a>, <a href="#jasmine_test_rule-entry_point">entry_point</a>, <a href="#jasmine_test_rule-env">env</a>,
                  <a href="#jasmine_test_rule-expected_exit_code">expected_exit_code</a>, <a href="#jasmine_test_rule-include_declarations">include_declarations</a>, <a href="#jasmine_test_rule-include_npm">include_npm</a>, <a href="#jasmine_test_rule-include_npm_linked_packages">include_npm_linked_packages</a>,
                  <a href="#jasmine_test_rule-include_transitive_sources">include_transitive_sources</a>, <a href="#jasmine_test_rule-junit_reporter">junit_reporter</a>, <a href="#jasmine_test_rule-log_level">log_level</a>, <a href="#jasmine_test_rule-node_options">node_options</a>, <a href="#jasmine_test_rule-patch_node_fs">patch_node_fs</a>,
                  <a href="#jasmine_test_rule-preserve_symlinks_main">preserve_symlinks_main</a>)
</pre>

Runs tests in NodeJS using the Jasmine test runner.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="jasmine_test_rule-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="jasmine_test_rule-chdir"></a>chdir |  Working directory to run the binary or test in, relative to the workspace.<br><br>        By default, <code>js_binary</code> runs in the root of the output tree.<br><br>        To run in the directory containing the <code>js_binary</code> use<br><br>            chdir = package_name()<br><br>        (or if you're in a macro, use <code>native.package_name()</code>)<br><br>        WARNING: this will affect other paths passed to the program, either as arguments or in configuration files,         which are workspace-relative.<br><br>        You may need <code>../../</code> segments to re-relativize such paths to the new working directory.         In a <code>BUILD</code> file you could do something like this to point to the output path:<br><br>        <pre><code>python         js_binary(             ...             chdir = package_name(),             # ../.. segments to re-relative paths from the chdir back to workspace;             # add an additional 3 segments to account for running js_binary running             # in the root of the output tree             args = ["/".join([".."] * len(package_name().split("/"))) + "$(rootpath //path/to/some:file)"],         )         </code></pre>   | String | optional | <code>""</code> |
| <a id="jasmine_test_rule-config"></a>config |  -   | <a href="https://bazel.build/concepts/labels">Label</a> | optional | <code>None</code> |
| <a id="jasmine_test_rule-copy_data_to_bin"></a>copy_data_to_bin |  When True, <code>data</code> files and the <code>entry_point</code> file are copied to the Bazel output tree before being passed         as inputs to runfiles.<br><br>        Defaults to True so that a <code>js_binary</code> with the default value is compatible with <code>js_run_binary</code> with         <code>use_execroot_entry_point</code> set to True, the default there.<br><br>        Setting this to False is more optimal in terms of inputs, but there is a yet unresolved issue of ESM imports         skirting the node fs patches and escaping the sandbox: https://github.com/aspect-build/rules_js/issues/362.         This is hit in some popular test runners such as mocha, which use native <code>import()</code> statements         (https://github.com/aspect-build/rules_js/pull/353). When set to False, a program such as mocha that uses ESM         imports may escape the execroot by following symlinks into the source tree. When set to True, such a program         would escape the sandbox but will end up in the output tree where <code>node_modules</code> and other inputs required         will be available.   | Boolean | optional | <code>True</code> |
| <a id="jasmine_test_rule-data"></a>data |  Runtime dependencies of the program.<br><br>        The transitive closure of the <code>data</code> dependencies will be available in         the .runfiles folder for this binary/test.<br><br>        You can use the <code>@bazel/runfiles</code> npm library to access these files         at runtime.<br><br>        npm packages are also linked into the <code>.runfiles/node_modules</code> folder         so they may be resolved directly from runfiles.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional | <code>[]</code> |
| <a id="jasmine_test_rule-enable_runfiles"></a>enable_runfiles |  Whether runfiles are enabled in the current build configuration.<br><br>        Typical usage of this rule is via a macro which automatically sets this         attribute based on a <code>config_setting</code> rule.   | Boolean | required |  |
| <a id="jasmine_test_rule-entry_point"></a>entry_point |  The main script which is evaluated by node.js.<br><br>        This is the module referenced by the <code>require.main</code> property in the runtime.<br><br>        This must be a target that provides a single file or a <code>DirectoryPathInfo</code>         from <code>@aspect_bazel_lib//lib::directory_path.bzl</code>.<br><br>        See https://github.com/aspect-build/bazel-lib/blob/main/docs/directory_path.md         for more info on creating a target that provides a <code>DirectoryPathInfo</code>.   | <a href="https://bazel.build/concepts/labels">Label</a> | required |  |
| <a id="jasmine_test_rule-env"></a>env |  Environment variables of the action.<br><br>        Subject to <code>$(location)</code> and make variable expansion.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional | <code>{}</code> |
| <a id="jasmine_test_rule-expected_exit_code"></a>expected_exit_code |  The expected exit code.<br><br>        Can be used to write tests that are expected to fail.   | Integer | optional | <code>0</code> |
| <a id="jasmine_test_rule-include_declarations"></a>include_declarations |  When True, <code>declarations</code> and <code>transitive_declarations</code> from <code>JsInfo</code> providers in data targets are included in the runfiles of the target.<br><br>        Defaults to false since declarations are generally not needed at runtime and introducing them could slow down developer round trip         time due to having to generate typings on source file changes.   | Boolean | optional | <code>False</code> |
| <a id="jasmine_test_rule-include_npm"></a>include_npm |  When True, npm is included in the runfiles of the target.<br><br>        An npm binary is also added on the PATH so tools can spawn npm processes. This is a bash script         on Linux and MacOS and a batch script on Windows.<br><br>        A minimum of rules_nodejs version 5.7.0 is required which contains the Node.js toolchain changes         to use npm.   | Boolean | optional | <code>False</code> |
| <a id="jasmine_test_rule-include_npm_linked_packages"></a>include_npm_linked_packages |  When True, files in <code>npm_linked_packages</code> and <code>transitive_npm_linked_packages</code> from <code>JsInfo</code> providers in data targets are included in the runfiles of the target.<br><br>        <code>transitive_files</code> from <code>NpmPackageStoreInfo</code> providers in data targets are also included in the runfiles of the target.   | Boolean | optional | <code>True</code> |
| <a id="jasmine_test_rule-include_transitive_sources"></a>include_transitive_sources |  When True, <code>transitive_sources</code> from <code>JsInfo</code> providers in data targets are included in the runfiles of the target.   | Boolean | optional | <code>True</code> |
| <a id="jasmine_test_rule-junit_reporter"></a>junit_reporter |  -   | <a href="https://bazel.build/concepts/labels">Label</a> | optional | <code>None</code> |
| <a id="jasmine_test_rule-log_level"></a>log_level |  Set the logging level.<br><br>        Log from are written to stderr. They will be supressed on success when running as the tool         of a js_run_binary when silent_on_success is True. In that case, they will be shown         only on a build failure along with the stdout & stderr of the node tool being run.   | String | optional | <code>"error"</code> |
| <a id="jasmine_test_rule-node_options"></a>node_options |  Options to pass to the node invocation on the command line.<br><br>        https://nodejs.org/api/cli.html<br><br>        These options are passed directly to the node invocation on the command line.         Options passed here will take precendence over options passed via         the NODE_OPTIONS environment variable. Options passed here are not added         to the NODE_OPTIONS environment variable so will not be automatically         picked up by child processes that inherit that enviroment variable.   | List of strings | optional | <code>[]</code> |
| <a id="jasmine_test_rule-patch_node_fs"></a>patch_node_fs |  Patch the to Node.js <code>fs</code> API (https://nodejs.org/api/fs.html) for this node program         to prevent the program from following symlinks out of the execroot, runfiles and the sandbox.<br><br>        When enabled, <code>js_binary</code> patches the Node.js sync and async <code>fs</code> API functions <code>lstat</code>,         <code>readlink</code>, <code>realpath</code>, <code>readdir</code> and <code>opendir</code> so that the node program being         run cannot resolve symlinks out of the execroot and the runfiles tree. When in the sandbox,         these patches prevent the program being run from resolving symlinks out of the sandbox.<br><br>        When disabled, node programs can leave the execroot, runfiles and sandbox by following symlinks         which can lead to non-hermetic behavior.   | Boolean | optional | <code>True</code> |
| <a id="jasmine_test_rule-preserve_symlinks_main"></a>preserve_symlinks_main |  When True, the --preserve-symlinks-main flag is passed to node.<br><br>        This prevents node from following an ESM entry script out of runfiles and the sandbox. This can happen for <code>.mjs</code>         ESM entry points where the fs node patches, which guard the runfiles and sandbox, are not applied.         See https://github.com/aspect-build/rules_js/issues/362 for more information. Once #362 is resolved,         the default for this attribute can be set to False.<br><br>        This flag was added in Node.js v10.2.0 (released 2018-05-23). If your node toolchain is configured to use a         Node.js version older than this you'll need to set this attribute to False.<br><br>        See https://nodejs.org/api/cli.html#--preserve-symlinks-main for more information.   | Boolean | optional | <code>True</code> |


<a id="jasmine_test"></a>

## jasmine_test

<pre>
jasmine_test(<a href="#jasmine_test-name">name</a>, <a href="#jasmine_test-node_modules">node_modules</a>, <a href="#jasmine_test-generate_junit_xml">generate_junit_xml</a>, <a href="#jasmine_test-config">config</a>, <a href="#jasmine_test-kwargs">kwargs</a>)
</pre>

jasmine_test rule

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="jasmine_test-name"></a>name |  A unique name for this target.   |  none |
| <a id="jasmine_test-node_modules"></a>node_modules |  Label pointing to the linked node_modules target where jasmine is linked, e.g. <code>//:node_modules</code>.<br><br><code>jasmine</code> must be linked into the node_modules supplied. <code>jasmine-reporters</code> is also required by default when generate_junit_xml is True <code>jasmine-core</code> is required when using sharding.   |  none |
| <a id="jasmine_test-generate_junit_xml"></a>generate_junit_xml |  Add a custom reporter to output junit XML to <code>process.env.XML_OUTPUT_FILE</code> where Bazel expects to find it.<br><br>When enabled, <code>jasmine-reporters</code> must be linked to the supplied node_modules tree.   |  <code>True</code> |
| <a id="jasmine_test-config"></a>config |  jasmine config file. See: https://jasmine.github.io/setup/nodejs.html#configuration   |  <code>None</code> |
| <a id="jasmine_test-kwargs"></a>kwargs |  All other args from <code>js_test</code>. See https://github.com/aspect-build/rules_js/blob/main/docs/js_binary.md#js_test   |  none |


