#!/usr/bin/env bash

set -euo pipefail

# https://github.com/ehough/docker-nfs-server

docker run                                            \
  -e NFS_EXPORT_0='/nfs_share *(rw,no_subtree_check)' \
  -v /tmp/nfs:/nfs_share                              \
  --cap-add SYS_ADMIN                                 \
  -p 2049:2049                                        \
  erichough/nfs-server
