#!/usr/bin/env bash

set -euxo pipefail

readonly tag=$1
readonly do_push=$2

cd "$(dirname "$0")/../docker"

if [ "$tag" = "" ]; then
    readonly suffix=""
else
    readonly suffix=":$tag"
fi

readonly registry='docker.pkg.github.com/nontan-rh/quickjs'
readonly base_name_tag="$registry/quickjs-ci-base$suffix"

docker build . \
    --file "quickjs-ci-base.dockerfile" \
    --tag "$base_name_tag"
if [ "$do_push" = "true" ]; then
    docker push "$base_name_tag"
fi

build_variation() {
    local variation=$1
    local name="quickjs-ci-$variation"
    docker build . \
        --file "$name.dockerfile" \
        --build-arg "base=$base_name_tag" \
        --tag "$registry/$name$suffix"
    if [ "$do_push" = "true" ]; then
        docker push "$registry/$name$suffix"
    fi
}

build_variation 'emscripten'
