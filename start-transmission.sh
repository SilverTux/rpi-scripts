#!/usr/bin/env bash

set -euo pipefail

docker run -d \
  --name=transmission \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e TRANSMISSION_WEB_HOME=/combustion-release/ `#optional` \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -v /path/to/data:/config \
  -v /path/to/downloads:/downloads \
  -v /path/to/watch/folder:/watch \
  --restart unless-stopped \
  lscr.io/linuxserver/transmission:latest
