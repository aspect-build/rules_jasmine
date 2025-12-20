# Bazel rules for Jasmine

Runs the [Jasmine](https://jasmine.github.io/) JS testing tool under Bazel.

rules_jasmine is just a part of what Aspect provides:

-   _Need help?_ This ruleset has support provided by https://aspect.build/services.
-   See our other Bazel rules, especially those built for rules_js, such as rules_ts for TypeScript: https://github.com/aspect-build

## Installation

- Under bzlmod in Bazel 6: start from <https://registry.bazel.build/modules/aspect_rules_jasmine>
- Otherwise, from the [release you pick](https://github.com/aspect-build/rules_jasmine/releases),
  copy the WORKSPACE snippet into your `WORKSPACE` file.

## Usage

To run just the jasmine tests in a test pattern, you can use `bazel test --test_lang_filters=jasmine [target pattern...]`.

API Docs: https://registry.bazel.build/docs/aspect_rules_jasmine

See usage examples in the [`examples/`](https://github.com/aspect-build/rules_jasmine/tree/main/examples/) directory.

> Note that the examples rely on code in the `/WORKSPACE` file in the root of this repo.
