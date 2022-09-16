#!/usr/bin/env bash

set -euo pipefail

sudo sh -c 'echo 1 >  /proc/sys/vm/drop_caches'
