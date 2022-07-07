#!/usr/bin/env bash

set -euo pipefail

PLEX_BASE_DIR=${1:-${HOME}/tmp/plex}
PLEX_TV_DIR=/mnt/rpi

docker run -d \
  --name=plex \
  --net=host \
  -e PUID=1000 \
  -e PGID=1000 \
  -e VERSION=docker \
  -e PLEX_CLAIM= `#optional` \
  -v "${PLEX_BASE_DIR}/library:/config" \
  -v "${PLEX_TV_DIR}:/tv" \
  -v "${PLEX_BASE_DIR}/movies:/movies" \
  --restart unless-stopped \
  lscr.io/linuxserver/plex:latest
