#!/usr/bin/env bash

echo "Building kie-docker-ui..."
KIE_ARGUMENTS=" -Dkie.dockerui.privateHost=kieci01-docker.lab.eng.brq.redhat.com -Dkie.dockerui.publicHost=kieci01-docker.lab.eng.brq.redhat.com "
KIE_ARGUMENTS=" $KIE_ARGUMENTS -Dkie.artifacts.deploy.path=/home/docker/docker-romartin/kie-docker-ui/tmp/artifacts/artifacts ";
KIE_ARGUMENTS=" $KIE_ARGUMENTS -Dkie.dockerui.jenkinsURL=https://brms-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/job/kie-docker-images "

mvn clean install $KIE_ARGUMENTS 

# Working directory and exit status.
exit $?