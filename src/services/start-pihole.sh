#!/bin/bash

# https://github.com/pi-hole/docker-pi-hole/blob/master/README.md
# https://docs.pi-hole.net/main/prerequisites/
# https://github.com/pi-hole/docker-pi-hole/#running-pi-hole-dockera

# Adblock lists
# https://github.com/blocklistproject/Lists

PIHOLE_BASE="${PIHOLE_BASE:-$(pwd)}"
[[ -d "$PIHOLE_BASE" ]] || mkdir -p "$PIHOLE_BASE" || { echo "Couldn't create storage directory: $PIHOLE_BASE"; exit 1; }
NAME=$(basename $0 | sed -e "s/^start-//" -e "s/.sh$//")
IMAGE="pihole/pihole:latest"

if [ "${RPI_SERVICE_UPDATE}" = "True" ]; then
  docker pull "${IMAGE}"
fi

# Note: ServerIP should be replaced with your external ip.
docker run -d \
    --name "${NAME}" \
    -p 53:53/tcp -p 53:53/udp \
    -p 80:80 \
    -e TZ="America/Chicago" \
    -v "${PIHOLE_BASE}/etc-pihole:/etc/pihole" \
    -v "${PIHOLE_BASE}/etc-dnsmasq.d:/etc/dnsmasq.d" \
    --dns=127.0.0.1 --dns=1.1.1.1 \
    --restart=unless-stopped \
    --hostname pi.hole \
    -e VIRTUAL_HOST="pi.hole" \
    -e PROXY_LOCATION="pi.hole" \
    -e ServerIP="80.98.88.40" \
    "${IMAGE}"

printf 'Starting up pihole container '
for i in $(seq 1 20); do
    if [ "$(docker inspect -f "{{.State.Health.Status}}" pihole)" == "healthy" ] ; then
        printf ' OK'
        echo -e "\n$(docker logs pihole 2> /dev/null | grep 'password:') for your pi-hole: https://${IP}/admin/"
        exit 0
    else
        sleep 3
        printf '.'
    fi

    if [ $i -eq 20 ] ; then
        echo -e "\nTimed out waiting for Pi-hole start, consult your container logs for more info (\`docker logs pihole\`)"
        exit 1
    fi
done;
