#!/bin/sh

set -e

# auth
export auth=$(echo -n "${username}:${password}" | base64)
envsubst < /root/.docker/config.template.json > /root/.docker/config.json

# until buildkit uses latest tag by default; need to provide explicit cache tag
digest=$(cat /cacheDir/index.json | jp -u "manifests[?annotations.\"org.opencontainers.image.ref.name\"=='latest'].digest | [0]")

# ensure valid cache layout exists
cp -R /default_cache/. /cacheDir

buildctl-daemonless.sh \
  build \
  --frontend dockerfile.v0 \
  --local context=/buildContext \
  --local dockerfile=/ \
  --output type=oci,dest=/image.tar \
  --import-cache "type=local,src=/cacheDir,digest=$digest" \
  --export-cache type=local,dest=/cacheDir