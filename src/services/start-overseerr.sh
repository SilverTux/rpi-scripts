#!/usr/bin/env bash

set -euo pipefail

OVERSEERR_BASE_DIR=${1:-${HOME}/tmp/overseerr}
NAME=$(basename $0 | sed -e "s/^start-//" -e "s/.sh$//")
IMAGE="lscr.io/linuxserver/overseerr:latest"

if [ "${RPI_SERVICE_UPDATE}" = "True" ]; then
  docker pull "${IMAGE}"
fi

docker run -d \
  --name="${NAME}" \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 5055:5055 \
  -v ${OVERSEERR_BASE_DIR}:/config \
  --restart unless-stopped \
  "${IMAGE}"
