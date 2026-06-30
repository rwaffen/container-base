#!/bin/bash

source /etc/os-release

# Create puppet user and group, and set permissions on necessary directories
# Used for rootless execution of the container and to match permissions expected by Puppet Server
if [ "$ID" = "alpine" ]; then
  apk update && apk upgrade
  addgroup -g "${OPENVOX_GID}" "${OPENVOX_GROUP_NAME}"
  adduser \
    -G "${OPENVOX_GROUP_NAME}" \
    -u "${OPENVOX_UID}" \
    -h "${OPENVOX_USER_HOME}" \
    -H -D \
    -s "${OPENVOX_USER_SHELL}" \
    "${OPENVOX_USER_NAME}"
elif [ "$ID" = "ubuntu" ] || [ "$ID" = "debian" ]; then
  apt update && apt upgrade -y
  groupadd --gid "${OPENVOX_GID}" "${OPENVOX_GROUP_NAME}"
  useradd \
    --gid "${OPENVOX_GID}" \
    --home-dir "${OPENVOX_USER_HOME}" \
    --no-create-home \
    --shell "${OPENVOX_USER_SHELL}" \
    --uid "${OPENVOX_UID}" \
    "${OPENVOX_USER_NAME}"
fi
