#!/bin/sh

set -e

# auth
export auth=$(echo -n "${username}:${password}" | base64)
envsubst < /root/.docker/config.template.json > /root/.docker/config.json

# busybox cp doesn't have --no-clobber; use mv instead to ensure valid cacheDir exists
cp -R /default_cache/. /default_cache_cp
mv --no-clobber /default_cache_cp/* /cacheDir

# until buildkit uses latest tag by default; need to provide explicit cache tag
digest=$(cat /cacheDir/index.json | jp -u "manifests[?annotations.\"org.opencontainers.image.ref.name\"=='latest'].digest | [0]")

buildctl-daemonless.sh \
  build \
  --frontend dockerfile.v0 \
  --local context=/buildContext \
  --local dockerfile=/ \
  --output type=oci,dest=/image.tar \
  --import-cache "type=local,src=/cacheDir,digest=$digest" \
  --export-cache type=local,dest=/cacheDir

# @todo remove once https://github.com/moby/buildkit/issues/1219
echo "untarring image"
tar -xf /image.tar -C /image