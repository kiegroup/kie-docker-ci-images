#!/usr/bin/env bash

# Start WildFly with some parameters.
./standalone.sh -b $JBOSS_BIND_ADDRESS -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true --server-config=standalone-full-kie-server.xml
exit $?