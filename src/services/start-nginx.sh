#!/usr/bin/env bash

set -euo pipefail

NGINX_BASE_DIR=${1:-${HOME}/tmp/nginx}
NAME=$(basename $0 | sed -e "s/^start-//" -e "s/.sh$//")
IMAGE="lscr.io/linuxserver/nginx:latest"

if [ "${RPI_SERVICE_UPDATE}" = "True" ]; then
  docker pull "${IMAGE}"
fi

docker run -d \
  --name="${NAME}" \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 5555:80 \
  -p 443:443 \
  -v ${NGINX_BASE_DIR}:/config \
  --restart unless-stopped \
  "${IMAGE}"
