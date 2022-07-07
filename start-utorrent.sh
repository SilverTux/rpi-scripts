#!/usr/bin/env bash

set -euo pipefail

docker run                                            \
    --name utorrent                                   \
    -v /tmp/utorrent:/data                            \
    -p 8080:8080                                      \
    -p 6881:6881                                      \
    -p 6881:6881/udp                                  \
    ekho/utorrent:latest
