# Bazel rules for Jasmine

Runs the [Jasmine](https://jasmine.github.io/) JS testing tool under Bazel.

## Installation

From the release you wish to use:
<https://github.com/aspect-build/rules_jasmine/releases>
copy the WORKSPACE snippet into your `WORKSPACE` file.

## Usage

To run just the jasmine tests in a test pattern, you can use `bazel test --test_lang_filters=jasmine [target pattern...]`.

API Docs

- [jasmine_test](./docs/jasmine_test): runs Jasmine under `bazel test`

See usage examples in the [`examples/`](https://github.com/aspect-build/rules_jasmine/tree/main/examples/) directory.

> Note that the examples rely on code in the `/WORKSPACE` file in the root of this repo.
