#!/usr/bin/env bash
# Produce a dictionary for the current esbuild release,
# suitable for appending to esbuild/private/versions.bzl
set -o errexit -o nounset
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

version="${1:-$(curl --silent "https://registry.npmjs.org/jasmine/latest" | jq --raw-output ".version")}"
reporter_version="${2:-$(curl --silent "https://registry.npmjs.org/jasmine-reporters/latest" | jq --raw-output ".version")}"

out="$SCRIPT_DIR/../jasmine/private/v${version}"
mkdir -p "$out"

cd $(mktemp -d)
npx pnpm install "jasmine@$version" "jasmine-reporters@$reporter_version"  --lockfile-only
cp pnpm-lock.yaml "$out"
cp package.json "$out"
echo "Mirrored jasmine version $version to $out. Now add it to jasmine/private/versions.bzl"
