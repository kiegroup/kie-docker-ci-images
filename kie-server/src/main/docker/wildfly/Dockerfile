####### BASE ############
FROM jboss/wildfly:11.0.0.Final

####### MAINTAINER ############
MAINTAINER "Roger Martinez" "romartin@redhat.com"

####### LOCALE ############
ENV LANG en_US.UTF-8

####### ENVIRONMENT ############
ENV JAVA_OPTS -Xms256m -Xmx512m
ENV JBOSS_BIND_ADDRESS 0.0.0.0
LABEL org.kie.kie-server.artifact=org.kie.server:kie-server:war:ee7

####### SYSTEM USERS FOR DEVELOPMENT ############
USER root
# Set a password for root & jboss users (for any further system operations, etc)
RUN echo "root:rootman" | chpasswd && \
echo "jboss:jboss" | chpasswd

####### KIE-SERVER & WILDFLY10 CONFIG FILES ############
# Latest WAR from Maven repository & Custom WildFly configuration files
# There is an issue in Docker with ADD command.
# When a file is added into the container's filesystem, the file owner is always root, instead of the current running user.
# See https://github.com/docker/docker/issues/5110
# The workaround is doing a chown using root user and then switchback to jboss user.

# WildFly custom configuration.
ADD etc/kie-server-users.properties $JBOSS_HOME/standalone/configuration/kie-server-users.properties
ADD etc/kie-server-roles.properties $JBOSS_HOME/standalone/configuration/kie-server-roles.properties
ADD etc/standalone-full-kie-server.xml $JBOSS_HOME/standalone/configuration/standalone-full-kie-server.xml

# Custom kie-server WildFly startup scripts.
ADD etc/start_kie-server.sh $JBOSS_HOME/bin/start_kie-server.sh

# Add the kie-server WAR artifact from the assembly result.
ADD maven/kie-server.war $JBOSS_HOME/standalone/deployments/kie-server-archive.war

# Work with unpacked WAR archives in WildFly, so other images can override webapp files (such as persistence.xml,etc)
RUN unzip -q -d $JBOSS_HOME/standalone/deployments/kie-server.war $JBOSS_HOME/standalone/deployments/kie-server-archive.war && \
touch $JBOSS_HOME/standalone/deployments/kie-server.war.dodeploy && \
rm -rf $JBOSS_HOME/standalone/deployments/kie-server-archive.war
# Set right permissions for jboss user.
RUN chown -R jboss:jboss $JBOSS_HOME/standalone/deployments/* && \
chmod +x $JBOSS_HOME/bin/*.sh && \
chown jboss:jboss $JBOSS_HOME/bin/start_kie-server.sh && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/kie-server-users.properties && \ 
chown jboss:jboss $JBOSS_HOME/standalone/configuration/kie-server-roles.properties && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/standalone-full-kie-server.xml && \
chown -R jboss:jboss $JBOSS_HOME/modules/system/layers/base/*

# Switchback to jboss user
USER jboss

####### COMMAND ############
WORKDIR $JBOSS_HOME/bin/
CMD ["./start_kie-server.sh"]