#!/usr/bin/env bash

set -euo pipefail

SONARR_BASE_DIR=${1:-${HOME}/tmp/sonarr}
NAME=$(basename $0 | sed -e "s/^start-//" -e "s/.sh$//")
IMAGE="lscr.io/linuxserver/sonarr:latest"

if [ "${RPI_SERVICE_UPDATE}" = "True" ]; then
  docker pull "${IMAGE}"
fi

docker run -d \
  --name="${NAME}" \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 8989:8989 \
  -v ${SONARR_BASE_DIR}/data:/config \
  -v ${SONARR_BASE_DIR}/tvseries:/tv `#optional` \
  -v ${SONARR_BASE_DIR}/downloads:/downloads `#optional` \
  --restart unless-stopped \
  "${IMAGE}"
