#!/usr/bin/env bash

set -euo pipefail

SSH_CONFIG=${HOME}/tmp/openssh-server
NAME=$(basename $0 | sed -e "s/^start-//" -e "s/.sh$//")
IMAGE="lscr.io/linuxserver/openssh-server:latest"

if [ "${RPI_SERVICE_UPDATE}" = "True" ]; then
  docker pull "${IMAGE}"
fi

#  -e PUBLIC_KEY=yourpublickey `#optional` \
#  -e PUBLIC_KEY_FILE=/path/to/file `#optional` \
#  -e PUBLIC_KEY_DIR=/path/to/directory/containing/_only_/pubkeys `#optional` \
#  -e PUBLIC_KEY_URL=https://github.com/username.keys `#optional` \
#  -e USER_PASSWORD_FILE=/path/to/file `#optional` \

docker run -d \
  --name="${NAME}" \
  --hostname=openssh-server `#optional` \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Budapest \
  -e SUDO_ACCESS=true `#optional` \
  -e PASSWORD_ACCESS=true `#optional` \
  -e USER_PASSWORD=password `#optional` \
  -e USER_NAME=istvan `#optional` \
  -p 2222:2222 \
  -v ${SSH_CONFIG}:/config \
  -v /tmp:/tmp \
  --restart unless-stopped \
  "${IMAGE}"
