#!/bin/bash

set -euxo pipefail

build=$(buildah from gcc:latest)

buildah run $build -- mkdir /build
buildah unshare \
    --mount MOUNT_POINT=$build \
    -- \
    sh -c 'cp -arv Makefile *.c $MOUNT_POINT/build'

buildah run $build -- make -C /build

out=$(buildah from gcr.io/distroless/static-debian10)

buildah unshare \
    --mount BUILD_MOUNT=$build \
    --mount OUT_MOUNT=$out \
    -- \
    sh -c 'cp -a $BUILD_MOUNT/build/hello $OUT_MOUNT/bin/'

buildah rm $build

buildah config \
    --author 'William Good' \
    --cmd '/bin/hello' \
    $out

buildah commit $out hello
buildah rm $out
