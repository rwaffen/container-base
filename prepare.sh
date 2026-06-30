#!/bin/bash

source /etc/os-release

if [ -z "${OPENVOX_UID}" ]; then
  OPENVOX_UID=64604
fi

if [ -z "${OPENVOX_GID}" ]; then
  OPENVOX_GID=64604
fi

if [ -z "${OPENVOX_USER_NAME}" ]; then
  OPENVOX_USER_NAME=puppet
fi

if [ -z "${OPENVOX_GROUP_NAME}" ]; then
  OPENVOX_GROUP_NAME=puppet
fi

if [ -z "${OPENVOX_USER_HOME}" ]; then
  OPENVOX_USER_HOME=/opt/puppetlabs/${OPENVOX_USER_NAME}
fi

if [ -z "${OPENVOX_USER_SHELL}" ]; then
  OPENVOX_USER_SHELL=/sbin/nologin
fi

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
