#!/usr/bin/env bash
set -e
# Program arguments:
# 1.- The KIE version to use

if [ $# -ne 1 ];
then
    echo "[ERROR] Missing KIE Version as first argument. Exiting!"
    exit 65
fi

KIE_VERSION=$1
SCRIPTS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# extract timestamp from the version string. This assumes the version is in format <6-chars><timestamp>, for example
# version 6.4.0.20150922-142344 will result in timestamp "20150922-142344"
TIMESTAMP=`echo ${KIE_VERSION} | cut -c 7-`

cd ${SCRIPTS_DIR}/..
DASHBUILDER_VERSION=`mvn -B -e org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=docker.dashbuilder.artifacts.version | grep -v '\['`
DASHBUILDER_BASE_VERSION=`echo ${DASHBUILDER_VERSION} | cut -c -5`
echo "Dashbuilder version: $DASHBUILDER_VERSION"
echo "Base Dashbuilder version: $DASHBUILDER_BASE_VERSION"
mvn -B -N -e versions:update-parent -DparentVersion=[${KIE_VERSION}] -DallowSnapshots=true -DgenerateBackupPoms=false
sed -i "s/<docker\.build\.dashbuilder\.tag>.*<\/docker\.build\.dashbuilder\.tag>/<docker\.build\.dashbuilder\.tag>${DASHBUILDER_BASE_VERSION}.${TIMESTAMP}<\/docker\.build\.dashbuilder\.tag>/" pom.xml
