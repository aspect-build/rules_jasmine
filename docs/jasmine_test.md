<!-- Generated with Stardoc: http://skydoc.bazel.build -->

rules_jasmine public API

<a id="jasmine_test"></a>

## jasmine_test

<pre>
jasmine_test(<a href="#jasmine_test-name">name</a>, <a href="#jasmine_test-node_modules">node_modules</a>, <a href="#jasmine_test-jasmine_reporters">jasmine_reporters</a>, <a href="#jasmine_test-config">config</a>, <a href="#jasmine_test-timeout">timeout</a>, <a href="#jasmine_test-size">size</a>, <a href="#jasmine_test-data">data</a>, <a href="#jasmine_test-kwargs">kwargs</a>)
</pre>

Runs jasmine under `bazel test`

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="jasmine_test-name"></a>name |  A unique name for this target.   |  none |
| <a id="jasmine_test-node_modules"></a>node_modules |  Label pointing to the linked node_modules target where jasmine is linked, e.g. <code>//:node_modules</code>.<br><br><code>jasmine</code> must be linked into the node_modules supplied. <code>jasmine-reporters</code> is also required by default when jasmine_reporters is True <code>jasmine-core</code> is required when using sharding.   |  none |
| <a id="jasmine_test-jasmine_reporters"></a>jasmine_reporters |  Whether <code>jasmine-reporters</code> is present in the supplied node_modules tree.<br><br>When enabled, adds a custom reporter to output junit XML to the path where Bazel expects to find it.   |  <code>True</code> |
| <a id="jasmine_test-config"></a>config |  jasmine config file. See: https://jasmine.github.io/setup/nodejs.html#configuration   |  <code>None</code> |
| <a id="jasmine_test-timeout"></a>timeout |  standard attribute for tests. Defaults to "short" if both timeout and size are unspecified.   |  <code>None</code> |
| <a id="jasmine_test-size"></a>size |  standard attribute for tests   |  <code>None</code> |
| <a id="jasmine_test-data"></a>data |  Runtime dependencies that Jasmine should be able to read.<br><br>This should include all test files, configuration files & files under test.   |  <code>[]</code> |
| <a id="jasmine_test-kwargs"></a>kwargs |  Additional named parameters from <code>js_test</code>. See [js_test docs](https://github.com/aspect-build/rules_js/blob/main/docs/js_binary.md#js_test)   |  none |


