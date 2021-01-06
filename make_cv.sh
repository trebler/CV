#!/bin/bash

set -e

DOCKER_BUILDKIT=1 docker build . -t cv
docker create --name dummy cv
docker cp dummy:/cv.pdf cv.pdf
docker rm -f dummy