#!/usr/bin/env bash

set -euo pipefail

BAZARR_BASE_DIR=${1:-${HOME}/tmp/bazarr}
SSD_DIR=${HOME}/ssd/data
NAME=$(basename $0 | sed -e "s/^start-//" -e "s/.sh$//")
IMAGE="lscr.io/linuxserver/bazarr:latest"

if [ "${RPI_SERVICE_UPDATE}" = "True" ]; then
  docker pull "${IMAGE}"
fi

docker run -d \
  --name="${NAME}" \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 6767:6767 \
  -v ${BAZARR_BASE_DIR}/config:/config \
  -v ${SSD_DIR}:/data `#optional` \
  --restart unless-stopped \
  "${IMAGE}"
