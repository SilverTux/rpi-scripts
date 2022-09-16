#!/usr/bin/env bash

set -euo pipefail

HOMEASSISTANT_BASE_DIR=${1:-${HOME}/homeassistant}

docker run -d \
  --name homeassistant \
  --privileged \
  --restart=unless-stopped \
  -e TZ=Europe/Budapest \
  -v "${HOMEASSISTANT_BASE_DIR}:/config" \
  --network=host \
  ghcr.io/home-assistant/home-assistant:stable
