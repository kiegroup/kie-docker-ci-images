#!/usr/bin/env bash
set -e

# Program arguments:
# 1. - The KIE version to use
# 2. - Additional Maven arguments (optional)

if [ $# -eq 1 ]; then
    KIE_VERSION=$1
elif [ $# -eq 2 ]; then
    KIE_VERSION=$1
    ADDITIONAL_MAVEN_ARGS=$2
else
    echo "[ERROR] Incorrect number of params! KIE Version needs to be specified as first param and (optionally) additional Maven arguments as second param. Exiting!"
    exit 65
fi

SCRIPTS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# extract timestamp from the version string. This assumes the version is in format <6-chars><timestamp>, for example
# version 6.4.0.20150922-142344 will result in timestamp "20150922-142344"
TIMESTAMP=`echo ${KIE_VERSION} | cut -c 7-`

cd ${SCRIPTS_DIR}/..
DASHBUILDER_VERSION=`mvn -B -e ${ADDITIONAL_MAVEN_ARGS} org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=docker.dashbuilder.artifacts.version | grep -v '\['`
DASHBUILDER_BASE_VERSION=`echo ${DASHBUILDER_VERSION} | cut -c -5`
echo "Dashbuilder version: $DASHBUILDER_VERSION"
echo "Base Dashbuilder version: $DASHBUILDER_BASE_VERSION"
mvn -B -N -e ${ADDITIONAL_MAVEN_ARGS} versions:update-parent -DparentVersion=[${KIE_VERSION}] -DallowSnapshots=true -DgenerateBackupPoms=false
sed -i "s/<docker\.build\.dashbuilder\.tag>.*<\/docker\.build\.dashbuilder\.tag>/<docker\.build\.dashbuilder\.tag>${DASHBUILDER_BASE_VERSION}.${TIMESTAMP}<\/docker\.build\.dashbuilder\.tag>/" pom.xml
