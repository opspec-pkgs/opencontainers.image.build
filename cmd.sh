#!/bin/sh

set -e

apk add -U gettext

export auth=$(echo -n "${username}:${password}" | base64)

envsubst < /root/.docker/config.template.json > /root/.docker/config.json

cat /root/.docker/config.json

buildctl-daemonless.sh \
  build \
  --frontend dockerfile.v0 \
  --local context=/buildContext \
  --local dockerfile=/ \
  --output type=oci,dest=/image.tar \
  --import-cache type=local,src=cacheDir \
  --export-cache type=local,dest=cacheDir

