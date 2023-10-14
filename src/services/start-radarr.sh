#!/usr/bin/env bash

set -euo pipefail

RADARR_BASE_DIR=${1:-${HOME}/tmp/radarr}
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
  --restart unless-stopped \
  "${IMAGE}"
#  -v /path/to/movies:/movies `#optional` \
#  -v /path/to/downloadclient-downloads:/downloads `#optional` \
