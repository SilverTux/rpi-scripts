#!/usr/bin/env bash

set -euo pipefail

GIT_REPO="${GIT_REPO:-$(git -C $(dirname ${BASH_SOURCE[0]}) rev-parse --show-toplevel)}"
ACTION="NOP"
export RPI_SERVICE_UPDATE="False"

function usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

OPTIONS:
-h|--help   This help message
-s|--start  Start a containerized service
-t|--status Get service status
-u|--update Update the service (by removing current running instance and redeploy)
EOF
}

function main() {
  if [ "${ACTION}" = "START" ]; then
    echo "Starting ${SERVICE}..."
    "${GIT_REPO}/src/services/start-${SERVICE}.sh"
  elif [ "${ACTION}" = "STATUS" ]; then 
    echo "Status of ${SERVICE}:"
    docker ps --filter "name=${SERVICE}"
  elif [ "${ACTION}" = "UPDATE" ]; then 
    echo "Updating ${SERVICE}..."
    docker rm -f "${SERVICE}"

    export RPI_SERVICE_UPDATE="True"
    "${GIT_REPO}/src/services/start-${SERVICE}.sh"
    unset RPI_SERVICE_UPDATE

    printf "\nService ${SERVICE} updated!\n\n"
    docker ps --filter "name=${SERVICE}"
  fi
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
