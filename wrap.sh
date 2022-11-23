#!/bin/sh

f='-it'
if [ "$1" == "notty" ]; then
  f='-i'
  shift 1
fi

if [ -x "$(command -v podman)" ]; then
  ce=podman
elif [ -x "$(command -v docker)" ]; then
  ce=docker
else
  echo 'Did not find a container engine'
  exit 1
fi

$ce run --rm $f \
  --mount type=bind,source="$(pwd)",target=/mnt \
  docker.io/vmsh0/cc2530-contiki sh -c "cd /mnt && $*"

