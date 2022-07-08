#!/bin/bash

set -e

GIT_VERSION=$(git describe --long --dirty --always --tags)

docker buildx build --platform linux/amd64 --load . -t cv \
    --build-arg VERSION="$GIT_VERSION"

docker create --name dummy cv
docker cp dummy:/cv.pdf cv.pdf
docker rm -f dummy
