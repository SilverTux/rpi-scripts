#!/usr/bin/env bash

set -euo pipefail

GIT_REPO="${GIT_REPO:-$(git -C $(dirname ${BASH_SOURCE[0]}) rev-parse --show-toplevel)}"
ACTION="NOP"
export RPI_SERVICE_UPDATE="False"
MEDIA_SERVICES=( nfs nginx prowlarr radarr sonarr overseerr bazarr qbittorrent )

function usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

OPTIONS:
-h|--help   This help message
-s|--start  Start a containerized service
-p|--stop   Stop a service
-t|--status Get service status
-u|--update Update the service (by removing current running instance and redeploy)
EOF
}

function main() {
  SERVICES=()
  if [ "${SERVICE}" = "media" ]; then
    SERVICES+=( "${MEDIA_SERVICES[@]}" )
  else
    SERVICES+=( "${SERVICE}" )
  fi

  for service in "${SERVICES[@]}"
  do
    if [ "${ACTION}" = "START" ]; then
      echo "Starting ${service}..."
      "${GIT_REPO}/src/services/start-${service}.sh"
    elif [ "${ACTION}" = "STOP" ]; then 
      echo "Stoping ${service}..."
      docker rm -f "${service}"
    elif [ "${ACTION}" = "STATUS" ]; then 
      echo "Status of ${service}:"
      docker ps --filter "name=${service}"
    elif [ "${ACTION}" = "UPDATE" ]; then 
      echo "Updating ${service}..."
      docker rm -f "${service}"

      export RPI_SERVICE_UPDATE="True"
      "${GIT_REPO}/src/services/start-${service}.sh"
      unset RPI_SERVICE_UPDATE

      printf "\nService ${service} updated!\n\n"
      docker ps --filter "name=${service}"
    fi
  done
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      usage
      shift # past value
      exit 0
      ;;
    -s|--start)
      SERVICE="$2"
      ACTION="START"
      shift # past argument
      shift # past value
      ;;
    -p|--stop)
      SERVICE="$2"
      ACTION="STOP"
      shift # past argument
      shift # past value
      ;;
    -t|--status)
      SERVICE="$2"
      ACTION="STATUS"
      shift # past argument
      shift # past value
      ;;
    -u|--update)
      SERVICE="$2"
      ACTION="UPDATE"
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "Unknown option $1"
      usage
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

main
