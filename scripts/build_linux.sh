#!/usr/bin/env bash

set -euxo pipefail

readonly proj_dir="$(dirname "$0")/.."
readonly build_dir="$proj_dir/build-linux"
readonly cc="gcc"

rm -fr "$build_dir"
cp -r "$proj_dir/quickjs-src" "$build_dir"
make -C "$build_dir" QJSC_CC="$cc" CC="$cc" STRIP=true "$@"
