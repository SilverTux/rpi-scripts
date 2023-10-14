#!/usr/bin/env bash

set -euo pipefail

PLEX_BASE_DIR=${1:-${HOME}/tmp/plex}
NAME=$(basename $0 | sed -e "s/^start-//" -e "s/.sh$//")
IMAGE="lscr.io/linuxserver/plex:latest"

if [ "${RPI_SERVICE_UPDATE}" = "True" ]; then
  docker pull "${IMAGE}"
fi

NFS_VOL_NAME=plexnfs
NFS_LOCAL_MNT=/tv
NFS_SERVER=192.168.1.139
NFS_SHARE=/
NFS_OPTS=vers=4,soft

DOCKER_MOUNT_PARAMS="src=${NFS_VOL_NAME},dst=${NFS_LOCAL_MNT}"
DOCKER_MOUNT_PARAMS+=",volume-opt=device=:${NFS_SHARE}"
DOCKER_MOUNT_PARAMS+=",\"volume-opt=o=addr=${NFS_SERVER},${NFS_OPTS}\""
DOCKER_MOUNT_PARAMS+=",type=volume,volume-driver=local,volume-opt=type=nfs"

docker run -d \
  --name="${NAME}" \
  --net=host \
  -e PUID=1000 \
  -e PGID=1000 \
  -e VERSION=docker \
  -e PLEX_CLAIM= `#optional` \
  -v "${PLEX_BASE_DIR}/library:/config" \
  -v "${PLEX_BASE_DIR}/movies:/movies" \
  --mount ${DOCKER_MOUNT_PARAMS} \
  --restart unless-stopped \
  "${IMAGE}"
