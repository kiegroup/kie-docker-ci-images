#!/usr/bin/env bash
set -e

# Program arguments:
# 1. - The KIE version to use
# 2. - Additional Maven arguments (optional)

if [ $# -ge 1 ]; then
    KIE_VERSION=$1
    shift
    # everything after the first param is treated as additional maven args
    ADDITIONAL_MAVEN_ARGS="$@"
else
    echo "[ERROR] Incorrect number of params! KIE Version needs to be specified as first param and (optionally) additional Maven arguments as the other params. Exiting!"
    exit 65
fi

echo "KIE version: $KIE_VERSION"
echo "Additional Maven args: ${ADDITIONAL_MAVEN_ARGS[@]}"

SCRIPTS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# extract timestamp from the version string. This assumes the version is in format <6-chars><timestamp>, for example
# version 6.4.0.20150922-142344 will result in timestamp "20150922-142344"
TIMESTAMP=`echo ${KIE_VERSION} | cut -c 7-`

cd ${SCRIPTS_DIR}/..

# don't use versions:update-parent to update the parent version as that is buggy and often does not update the version for some reason
PARENT_VERSION=`mvn -B -e ${ADDITIONAL_MAVEN_ARGS[@]} org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.parent.version | grep -v '\['`
echo "Parsed parent version: $PARENT_VERSION"
sed -i "s/<version>$PARENT_VERSION<\/version>/<version>$KIE_VERSION<\/version>/" pom.xml
mvn -B -N -e ${ADDITIONAL_MAVEN_ARGS[@]} versions:update-child-modules -DallowSnapshots=true -DgenerateBackupPoms=false

DASHBUILDER_VERSION=`mvn -B -e ${ADDITIONAL_MAVEN_ARGS[@]} org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=docker.dashbuilder.artifacts.version | grep -v '\['`
DASHBUILDER_BASE_VERSION=`echo ${DASHBUILDER_VERSION} | cut -c -5`
echo "Dashbuilder version: $DASHBUILDER_VERSION"
echo "Base Dashbuilder version: $DASHBUILDER_BASE_VERSION"
sed -i "s/<docker\.build\.dashbuilder\.tag>.*<\/docker\.build\.dashbuilder\.tag>/<docker\.build\.dashbuilder\.tag>${DASHBUILDER_BASE_VERSION}.${TIMESTAMP}<\/docker\.build\.dashbuilder\.tag>/" pom.xml
