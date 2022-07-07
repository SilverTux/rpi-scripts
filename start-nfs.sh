#!/usr/bin/env bash

set -euo pipefail

# This one does not support arm (https://github.com/ehough/docker-nfs-server)
# https://github.com/sjiveson/nfs-server-alpine
# https://sysadmins.co.za/setup-a-nfs-server-with-docker/

# DO NOT forget to add the following line to client's /etc/fstab
# <server-IP>:/ /mnt/rpi    nfs4    rw,relatime,vers=4.0,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=<client-IP>,local_lock=none,addr=<server-IP>    0    0
NFS_SHARE=${1:-${HOME}/qbittorrent/downloads}

docker run                           \
  -d                                 \
  --name nfs-server                  \
  -e SHARED_DIRECTORY='/nfs_share'   \
  -v "${NFS_SHARE}:/nfs_share"       \
  --cap-add SYS_ADMIN                \
  -p 2049:2049                       \
  itsthenetwork/nfs-server-alpine:latest-arm
