#!/bin/bash

set -e

GIT_VERSION=$(git describe --long --dirty --always --tags)

docker buildx build . \
    --file Dockerfile \
    --platform linux/amd64 \
    --tag cv \
    --load \
    --build-arg VERSION="$GIT_VERSION"

docker run --rm cv >cv.pdf
