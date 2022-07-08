#!/bin/bash

set -e

usage() {
    echo "Usage: $0 [-r {DOCKER_REGISTRY}] [-t {DOCKER_IMAGE_TAG}] [-c]" 1>&2
    exit 1
}
while getopts ":r:t:hc" opt; do
    case ${opt} in
    r)
        DOCKER_REGISTRY=$OPTARG
        ;;
    t)
        TAG=$OPTARG
        ;;
    c)
        NO_CACHE=yes
        ;;
    h | [?])
        usage
        exit
        ;;
    esac
done
shift $((OPTIND - 1))

GIT_VERSION=$(git describe --long --dirty --always --tags)

if [ -z "$DOCKER_REGISTRY" ]; then
    DOCKER_REGISTRY="ghcr.io/trebler"
fi

DOCKER_BUILD_EXTRA_ARGS=()

if [ -n "$NO_CACHE" ]; then
    DOCKER_BUILD_EXTRA_ARGS+=("--no-cache" "--pull")
fi

IMAGE_NAME=cv

TAG_ARGS=(
    "--tag=$DOCKER_REGISTRY/$IMAGE_NAME:$GIT_VERSION"
    "--tag=$DOCKER_REGISTRY/$IMAGE_NAME:latest"
)

if [ -n "$TAG" ]; then
    TAG_ARGS+=("--tag=$DOCKER_REGISTRY/$IMAGE_NAME:$TAG")
fi

docker buildx build -f cv.dockerfile \
    --platform linux/arm/v6,linux/arm/v7,linux/amd64 --push .. \
    "${TAG_ARGS[@]}" \
    "${DOCKER_BUILD_EXTRA_ARGS[@]}"
