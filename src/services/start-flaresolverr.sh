#!/usr/bin/env bash

set -euo pipefail

FLARESOLVERR_BASE_DIR=${1:-${HOME}/tmp/flaresolverr}
NAME=$(basename $0 | sed -e "s/^start-//" -e "s/.sh$//")
IMAGE="ghcr.io/flaresolverr/flaresolverr:latest"

if [ "${RPI_SERVICE_UPDATE}" = "True" ]; then
  docker pull "${IMAGE}"
fi

docker run -d \
  --name="${NAME}" \
  -p 8191:8191 \
  -v ${FLARESOLVERR_BASE_DIR}:/config \
  --restart unless-stopped \
  "${IMAGE}"
