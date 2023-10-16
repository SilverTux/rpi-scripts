#!/usr/bin/env bash

set -euo pipefail

apt-get update
apt-get install -y \
    git \
    vim

# Install docker
curl -fsSL https://get.docker.com -o get-docker.sh
chmod +x get-docker.sh
./get-docker.sh
usermod -aG docker pi

# Turn off all swap
printf "\nSwap status before turn off\n"
swapon -s
swapoff -a
dphys-swapfile swapoff
sync; echo 1 > /proc/sys/vm/drop_caches
printf "\nSwap status after turn off\n"
swapon -s

# Install argonone scripts
curl https://download.argon40.com/argon1.sh | bash

# Install hacs
curl -fsSL https://raw.githubusercontent.com/hacs/get/main/get -o get-hacs.sh
chmod +x get-hacs.sh

# Install pihole
echo "curl -O https://raw.githubusercontent.com/pi-hole/docker-pi-hole/master/examples/docker_run.sh"

# Load nfs kernel module
modprobe nfsd
echo "nfsd" >> /etc/modules

# Edit crontab
echo "call 'crontab -e' and add the following line:"
echo "0 5 * * * /home/pi/rpi-scripts/src/utils/cleanup_memory.sh"

# Permanently mount ssd
echo "SSD UUID:"
ls -l /dev/disk/by-uuid/
blkid
echo "UUID=4922bf32-f137-45fb-ab44-cba26d455936 /home/pi/ssd/ ext4 defaults,auto,users,rw,nofail 0 0" >> /etc/fstab
chown pi:pi -R ssd
mount -a
