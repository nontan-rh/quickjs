#!/usr/bin/env bash

set -euxo pipefail

readonly proj_dir="$(dirname "$0")/.."
readonly build_dir="$proj_dir/build-emscripten"

rm -fr "$build_dir"
cp -r "$proj_dir/quickjs-src" "$build_dir"
make -C "$build_dir" CONFIG_CLANG=y CROSS_PREFIX=placeholder-cross-prefix- HOST_CC=clang CC=emcc QJSC_CC=emcc AR=emar STRIP=true EXE=.js "$@"
