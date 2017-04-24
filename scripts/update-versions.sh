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
cd ${SCRIPTS_DIR}/..
mvn -U -B -N -e ${ADDITIONAL_MAVEN_ARGS} versions:update-parent -DparentVersion=[${KIE_VERSION}] -DallowSnapshots=true -DgenerateBackupPoms=false
mvn -B -N -e ${ADDITIONAL_MAVEN_ARGS} versions:update-child-modules -DallowSnapshots=true -DgenerateBackupPoms=false
