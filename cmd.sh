#!/bin/sh

set -e

/setAuths

buildctl-daemonless.sh \
  build \
  --frontend dockerfile.v0 \
  --local context=/buildContext \
  --local dockerfile=/ \
  --output type=oci,tar=false,dest=/image \
  --import-cache type=local,src=/cacheDir \
  --export-cache type=local,dest=/cacheDir,mode=max