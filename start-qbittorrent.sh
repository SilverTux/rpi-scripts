#!/usr/bin/env bash

set -euo pipefail

QBITTORRENT_BASE_DIR=${1:-${HOME}/qbittorrent}

docker run -d \
  --name=qbittorrent \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Budapest \
  -e WEBUI_PORT=8080 \
  -p 8080:8080 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -v "${QBITTORRENT_BASE_DIR}/config:/config" \
  -v "${QBITTORRENT_BASE_DIR}/downloads:/downloads" \
  --restart unless-stopped \
  lscr.io/linuxserver/qbittorrent:latest
