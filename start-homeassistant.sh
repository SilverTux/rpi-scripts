#!/usr/bin/env bash

set -euo pipefail

docker run -d \
  --name homeassistant \
  --privileged \
  --restart=unless-stopped \
  -e TZ=Europe/Budapest \
  -v /home/pi/homeassistant:/config \
  --network=host \
  ghcr.io/home-assistant/home-assistant:stable
