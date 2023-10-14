#!/usr/bin/env bash

set -euo pipefail

HOMEASSISTANT_BASE_DIR=${1:-${HOME}/homeassistant}
NAME=$(basename $0 | sed -e "s/^start-//" -e "s/.sh$//")
IMAGE="ghcr.io/home-assistant/home-assistant:stable"

if [ "${RPI_SERVICE_UPDATE}" = "True" ]; then
  docker pull "${IMAGE}"
fi

docker run -d \
  --name "${NAME}" \
  --privileged \
  --restart=unless-stopped \
  -e TZ=Europe/Budapest \
  -v "${HOMEASSISTANT_BASE_DIR}:/config" \
  --network=host \
  "${IMAGE}"
