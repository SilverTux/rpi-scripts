#!/usr/bin/env bash

set -euo pipefail

TRANSMISSION_BASE_DIR=${1:-${HOME}/transmission}
NAME=$(basename $0 | sed -e "s/^start-//" -e "s/.sh$//")
IMAGE="lscr.io/linuxserver/transmission:latest"

if [ "${RPI_SERVICE_UPDATE}" = "True" ]; then
  docker pull "${IMAGE}"
fi

docker run -d \
  --name="${NAME}" \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Budapest \
  -e TRANSMISSION_WEB_HOME=/combustion-release/ `#optional` \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -v "${TRANSMISSION_BASE_DIR}/config:/config" \
  -v "${TRANSMISSION_BASE_DIR}/downloads:/downloads" \
  -v "${TRANSMISSION_BASE_DIR}/folder:/watch" \
  --restart unless-stopped \
  "${IMAGE}"
