#!/usr/bin/env bash

set -euo pipefail

RADARR_BASE_DIR=${1:-${HOME}/tmp/radarr}
SSD_DIR=${HOME}/ssd/data
NAME=$(basename $0 | sed -e "s/^start-//" -e "s/.sh$//")
IMAGE="lscr.io/linuxserver/radarr:latest"

if [ "${RPI_SERVICE_UPDATE}" = "True" ]; then
  docker pull "${IMAGE}"
fi

docker run -d \
  --name="${NAME}" \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 7878:7878 \
  -v ${RADARR_BASE_DIR}:/config \
  -v ${SSD_DIR}/media/movies:/movies `#optional` \
  -v ${SSD_DIR}/torrents:/downloads `#optional` \
  --restart unless-stopped \
  "${IMAGE}"
