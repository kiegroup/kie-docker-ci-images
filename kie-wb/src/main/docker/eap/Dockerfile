####### BASE ############
FROM ce-registry.usersys.redhat.com/jboss-eap-6/eap64:1.3

####### MAINTAINER ############
MAINTAINER "Roger Martinez" "romartin@redhat.com"

####### ENVIRONMENT ############
ENV JAVA_OPTS -Xms256m -Xmx1024m
ENV JBOSS_BIND_ADDRESS 0.0.0.0
ENV KIE_CONNECTION_URL jdbc:h2:mem:test;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE
ENV KIE_CONNECTION_DRIVER h2
ENV KIE_CONNECTION_USER sa
ENV KIE_CONNECTION_PASSWORD sa
ENV KIE_CONNECTION_DATABASE kie
LABEL org.kie.kie-wb.artifact=org.kie:kie-wb-distribution-wars:war:eap6_4
LABEL org.jbpm.jbpm-dashboard.artifact=org.jbpm.dashboard:jbpm-dashboard-distributions:war:eap6_4

####### SYTEM USERS FOR DEVELOPMENT ############
USER root
# Set a password for root & jboss users (for any further system operations, etc)
RUN echo "root:rootman" | chpasswd && \
echo "jboss:jboss" | chpasswd

####### KIE-WB & EAP 6.4 CONFIG FILES############
# Latest WAR from Maven repository & Custom EAP configuration files
# There is an issue in Docker with ADD command.
# When a file is added into the container's filesystem, the file owner is always root, instead of the current running user.
# See https://github.com/docker/docker/issues/5110
# The workaround is doing a chown using root user and then switchback to jboss user.

# EAP custom configuration.
ADD etc/kie-wb-users.properties $JBOSS_HOME/standalone/configuration/kie-wb-users.properties
ADD etc/kie-wb-roles.properties $JBOSS_HOME/standalone/configuration/kie-wb-roles.properties
ADD etc/standalone-full-kie-wb.xml $JBOSS_HOME/standalone/configuration/standalone-full-kie-wb.xml

# Custom kie-wb EAP startup scripts.
ADD etc/start_kie-wb.sh $JBOSS_HOME/bin/start_kie-wb.sh
ADD etc/update-jpa-config.sh $JBOSS_HOME/bin/update-jpa-config.sh

# Add the kie-wb & Dashboard Builder WAR artifacts from the assembly result.
ADD maven/kie-wb.war $JBOSS_HOME/standalone/deployments/kie-wb-archive.war
ADD maven/dashbuilder.war $JBOSS_HOME/standalone/deployments/dashbuilder-archive.war

# Database MySQL and PostgreSQL modules
ADD maven/modules/kie-eap-mysql-module.tar.gz $JBOSS_HOME/modules/system/layers/base
ADD maven/modules/kie-eap-postgres-module.tar.gz $JBOSS_HOME/modules/system/layers/base

# Work with unpacked WAR archives in EAP, so other images can override webapp files (such as persistence.xml,etc)
RUN unzip -q -d $JBOSS_HOME/standalone/deployments/kie-wb.war $JBOSS_HOME/standalone/deployments/kie-wb-archive.war && \
touch $JBOSS_HOME/standalone/deployments/kie-wb.war.dodeploy && \
rm -rf $JBOSS_HOME/standalone/deployments/kie-wb-archive.war && \
unzip -q -d $JBOSS_HOME/standalone/deployments/dashbuilder.war $JBOSS_HOME/standalone/deployments/dashbuilder-archive.war && \
touch $JBOSS_HOME/standalone/deployments/dashbuilder.war.dodeploy && \
rm -rf $JBOSS_HOME/standalone/deployments/dashbuilder-archive.war

# Copy jboss-all.xml for Dashbuilder webapp, it must be deployed after kie-wb.
ADD etc/jboss-all.xml $JBOSS_HOME/standalone/deployments/dashbuilder.war/META-INF/jboss-all.xml

# Set right permissions for jboss user.
RUN chown -R jboss:jboss $JBOSS_HOME/standalone/deployments/* && \
chmod +x $JBOSS_HOME/bin/*.sh && \
chown jboss:jboss $JBOSS_HOME/bin/start_kie-wb.sh && \
chown jboss:jboss $JBOSS_HOME/bin/update-jpa-config.sh && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/kie-wb-users.properties && \ 
chown jboss:jboss $JBOSS_HOME/standalone/configuration/kie-wb-roles.properties && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/standalone-full-kie-wb.xml && \
chown -R jboss:jboss $JBOSS_HOME/modules/system/layers/base/*
# Switchback to jboss user
USER jboss

####### EXPOSE INTERNAL KIE-WB GIT PORT ############
EXPOSE 8001

####### COMMAND ############
WORKDIR $JBOSS_HOME/bin/
CMD ["./start_kie-wb.sh"]