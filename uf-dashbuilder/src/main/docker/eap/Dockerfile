####### BASE ############
FROM docker-registry.usersys.redhat.com/cloud_enablement/jboss-eap:6.4-15

####### MAINTAINER ############
MAINTAINER "Roger Martinez" "romartin@redhat.com"

####### ENVIRONMENT ############
ENV JAVA_OPTS -XX:MaxPermSize=256m -Xms256m -Xmx512m
ENV JBOSS_BIND_ADDRESS 0.0.0.0
ENV KIE_CONNECTION_URL jdbc:h2:mem:test;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE
ENV KIE_CONNECTION_DRIVER h2
ENV KIE_CONNECTION_USER sa
ENV KIE_CONNECTION_PASSWORD sa
ENV KIE_CONNECTION_DATABASE kie
LABEL org.dashbuilder.artifact=org.dashbuilder:dashbuilder-distros:war:eap6_4

####### SYTEM USERS FOR DEVELOPMENT ############
USER root
# Set a password for root & jboss users (for any further system operations, etc)
RUN echo "root:rootman" | chpasswd && \
echo "jboss:jboss" | chpasswd

####### DASHBUILDER & EAP 6.4 CONFIG FILES############
# Latest WAR from Maven repository & Custom EAP configuration files
# There is an issue in Docker with ADD command.
# When a file is added into the container's filesystem, the file owner is always root, instead of the current running user.
# See https://github.com/docker/docker/issues/5110
# The workaround is doing a chown using root user and then switchback to jboss user.
# EAP custom configuration.
ADD etc/dashbuilder-users.properties $JBOSS_HOME/standalone/configuration/dashbuilder-users.properties
ADD etc/dashbuilder-roles.properties $JBOSS_HOME/standalone/configuration/dashbuilder-roles.properties
ADD etc/standalone-full-dashbuilder.xml $JBOSS_HOME/standalone/configuration/standalone-full-dashbuilder.xml
# Custom dashbuilder Wildfly startup scripts.
ADD etc/start_dashbuilder.sh $JBOSS_HOME/bin/start_dashbuilder.sh

# Add the dashbuilder WAR artifact from the assembly result.
ADD maven/dashbuilder.war $JBOSS_HOME/standalone/deployments/dashbuilder-archive.war
# Database MySQL and PostgreSQL modules
ADD maven/modules/kie-eap-mysql-module.tar.gz $JBOSS_HOME/modules/system/layers/base
ADD maven/modules/kie-eap-postgres-module.tar.gz $JBOSS_HOME/modules/system/layers/base

# The project site report for the build
ADD maven/site $JBOSS_HOME/standalone/deployments/site.war

# Work with unpacked WAR archives in Wilfly, so other images can override webapp files (such as persistence.xml,etc)
RUN unzip -q -d $JBOSS_HOME/standalone/deployments/dashbuilder.war $JBOSS_HOME/standalone/deployments/dashbuilder-archive.war && \
touch $JBOSS_HOME/standalone/deployments/dashbuilder.war.dodeploy && \
rm -rf $JBOSS_HOME/standalone/deployments/dashbuilder-archive.war && \
unzip -q -d $JBOSS_HOME/standalone/deployments/site.war $JBOSS_HOME/standalone/deployments/site.war/uf-dashbuilder-site.jar && \
rm -rf $JBOSS_HOME/standalone/deployments/site.war/uf-dashbuilder-site.jar && \
touch $JBOSS_HOME/standalone/deployments/site.war.dodeploy && \
chown -R jboss:jboss $JBOSS_HOME/standalone/deployments/* && \
chmod +x $JBOSS_HOME/bin/*.sh && \
chown jboss:jboss $JBOSS_HOME/bin/start_dashbuilder.sh && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/dashbuilder-users.properties && \ 
chown jboss:jboss $JBOSS_HOME/standalone/configuration/dashbuilder-roles.properties && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/standalone-full-dashbuilder.xml && \
chown -R jboss:jboss $JBOSS_HOME/modules/system/layers/base/*
# Switchback to jboss user
USER jboss

####### EXPOSE INTERNAL DASHBUILDER GIT PORT ############
# Dashbuilder still does not support interval VFS, not needed yet.
# EXPOSE 8001

####### COMMAND ############
WORKDIR $JBOSS_HOME/bin/
CMD ["./start_dashbuilder.sh"]