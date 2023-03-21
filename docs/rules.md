<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public API re-exports

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


