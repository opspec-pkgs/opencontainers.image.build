#!/bin/sh

set -e

/setAuths

buildctl-daemonless.sh \
  build \
  --frontend dockerfile.v0 \
  --local context=/buildContext \
  --local dockerfile=/ \
  --output type=oci,dest=/image.tar \
  --import-cache type=local,src=/cacheDir \
  --export-cache type=local,dest=/cacheDir

# @todo remove once https://github.com/moby/buildkit/issues/1219
echo "untarring image"
tar -xf /image.tar -C /image