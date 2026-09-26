#!/usr/bin/env bash

set -euo pipefail

SEERR_BASE_DIR=${1:-${HOME}/tmp/seerr}
NAME=$(basename $0 | sed -e "s/^start-//" -e "s/.sh$//")
IMAGE="ghcr.io/seerr-team/seerr:latest"

if [ "${RPI_SERVICE_UPDATE}" = "True" ]; then
  docker pull "${IMAGE}"
fi

docker run -d \
  --name="${NAME}" \
  --init \
  -e LOG_LEVEL=debug \
  -e TZ=Etc/UTC \
  -e PORT=5055 \
  -p 5055:5055 \
  -v ${SEERR_BASE_DIR}:/app/config \
  --restart unless-stopped \
  "${IMAGE}"
