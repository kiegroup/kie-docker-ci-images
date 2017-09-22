#!/usr/bin/env bash

# Stops and removes Docker containers and images created with the same version as passed to the script
# This is needed as we can't create multiple containers and images with same names
# It also stops and removed all containers (but not images) for the specified base version (e.g. all 6.3.0* containers
# for 6.3.x branch)

# Program arguments:
# 1.- The KIE Version, e.g. 6.4.0.20150922-165436

if [ $# -ne 1 ];
then
    echo "[ERROR] Missing KIE Version as first argument. Exiting!"
    exit 65
fi

KIE_VERSION=$1
SCRIPTS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# extract timestamp from the version string. This assumes the version is in format <6-chars><timestamp>, for example
# version 6.4.0.20150922-142344 will result in timestamp "20150922-142344"
BASE_VERSION=`echo ${KIE_VERSION} | cut -c -5`
TIMESTAMP=`echo ${KIE_VERSION} | cut -c 7-`
cd ${SCRIPTS_DIR}/..
DASHBUILDER_VERSION=`mvn -B -e org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=docker.dashbuilder.artifacts.version | grep -v '\['`
DASHBUILDER_BASE_VERSION=`echo ${DASHBUILDER_VERSION} | cut -c -5`

echo "Stopping containers with ${TIMESTAMP} in name"
docker ps | grep "${TIMESTAMP//./\\.}" | awk '{print $1}' | xargs -r docker stop
echo "Stopping containers with ${BASE_VERSION} in name"
docker ps | grep "${BASE_VERSION//./\\.}" | awk '{print $1}' | xargs -r docker stop
echo "Stopping containers with ${DASHBUILDER_BASE_VERSION} in name"
docker ps | grep "${DASHBUILDER_BASE_VERSION//./\\.}" | awk '{print $1}' | xargs -r docker stop

echo "Removing containers with ${TIMESTAMP} in name"
docker ps -a | grep "${TIMESTAMP//./\\.}" | awk '{print $1}' | xargs -r docker rm -f
echo "Removing containers with ${BASE_VERSION} in name"
docker ps -a | grep "${BASE_VERSION//./\\.}" | awk '{print $1}' | xargs -r docker rm -f
echo "Removing containers with ${DASHBUILDER_BASE_VERSION} in name"
docker ps -a | grep "${DASHBUILDER_BASE_VERSION//./\\.}" | awk '{print $1}' | xargs -r docker rm -f

# don't remove images for the base version, they should be removed periodically with other script
# we want to keep them around for some days in case needed
echo "Removing images with ${TIMESTAMP} in name"
docker images --no-trunc | grep "${TIMESTAMP//./\\.}" | awk '{print $3}' | xargs -r docker rmi -f
