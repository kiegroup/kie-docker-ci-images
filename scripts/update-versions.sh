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

cd ${SCRIPTS_DIR}/..
mvn -B -e versions:set -DnewVersion=${KIE_VERSION} -DallowSnapshots=true -DgenerateBackupPoms=false
