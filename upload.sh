#!/bin/sh
pass github-registry | docker login ghcr.io -u ralsina --password-stdin
docker run --rm --privileged \
        multiarch/qemu-user-static \
        --reset -p yes
docker build . --platform=aarch64 -t ghcr.io/ralsina/caddy-static:latest --push
docker build . -t ghcr.io/ralsina/caddy-static:latest --push

