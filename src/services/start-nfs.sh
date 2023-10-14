#!/usr/bin/env bash

set -euo pipefail

# This one does not support arm (https://github.com/ehough/docker-nfs-server)
# https://github.com/sjiveson/nfs-server-alpine
# https://sysadmins.co.za/setup-a-nfs-server-with-docker/

# DO NOT forget to add the following line to client's /etc/fstab
# <server-IP>:/ /mnt/rpi    nfs4    rw,relatime,vers=4.0,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=<client-IP>,local_lock=none,addr=<server-IP>    0    0
NFS_SHARE_DOWNLOADS=${1:-${HOME}/qbittorrent/downloads}
NFS_SHARE_SSD=${1:-${HOME}/ssd}
NAME=$(basename $0 | sed -e "s/^start-//" -e "s/.sh$//")
IMAGE="itsthenetwork/nfs-server-alpine:latest-arm"

if [ "${RPI_SERVICE_UPDATE}" = "True" ]; then
  docker pull "${IMAGE}"
fi

docker run                                         \
  -d                                               \
  --name "${NAME}"                                 \
  -e SHARED_DIRECTORY='/nfs_share'                 \
  -e SHARED_DIRECTORY_2='/nfs_share/ssd'           \
  -v "${NFS_SHARE_DOWNLOADS}:/nfs_share"           \
  -v "${NFS_SHARE_SSD}:/nfs_share/ssd"             \
  --cap-add SYS_ADMIN                              \
  -p 2049:2049                                     \
  "${IMAGE}"
