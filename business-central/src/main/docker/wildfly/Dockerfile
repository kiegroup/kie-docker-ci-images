####### BASE ############
FROM jboss/wildfly:23.0.2.Final

####### MAINTAINER ############
MAINTAINER "Michael Biarnes Kiefer" "mbiarnes@redhat.com"

####### LOCALE ############
ENV LANG en_US.UTF-8

####### ENVIRONMENT ############
ENV JAVA_OPTS -Xms512m -Xmx2048m
ENV JBOSS_BIND_ADDRESS 0.0.0.0
ENV KIE_CONNECTION_URL jdbc:h2:mem:test;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE
ENV KIE_CONNECTION_DRIVER h2
ENV KIE_CONNECTION_USER sa
ENV KIE_CONNECTION_PASSWORD sa
ENV KIE_CONNECTION_DATABASE kie
LABEL org.kie.business-central.artifact=org.kie:business-central:war:wildfly23

####### SYTEM USERS FOR DEVELOPMENT ############
USER root
# Set a password for root & jboss users (for any further system operations, etc)
RUN echo "root:rootman" | chpasswd && \
echo "jboss:jboss" | chpasswd

####### BUSINESS_CENTRAL & WILDFLY23 CONFIG FILES ############
# Latest WAR from Maven repository & Custom WildFly configuration files
# There is an issue in Docker with ADD command.
# When a file is added into the container's filesystem, the file owner is always root, instead of the current running user.
# See https://github.com/docker/docker/issues/5110
# The workaround is doing a chown using root user and then switchback to jboss user.
# WildFly custom configuration.
ADD etc/business-central-users.properties $JBOSS_HOME/standalone/configuration/business-central-users.properties
ADD etc/business-central-roles.properties $JBOSS_HOME/standalone/configuration/business-central-roles.properties
ADD etc/standalone-full-business-central.xml $JBOSS_HOME/standalone/configuration/standalone-full-business-central.xml
# Custom business-central WildFly startup scripts.
ADD etc/start_business-central.sh $JBOSS_HOME/bin/start_business-central.sh
ADD etc/update-jpa-config.sh $JBOSS_HOME/bin/update-jpa-config.sh
# Add the business-central WAR artifact from the assembly result.
ADD maven/business-central.war $JBOSS_HOME/standalone/deployments/business-central-archive.war

# Add the kie-server WAR artifact from the assembly result.
ADD maven/kie-server.war $JBOSS_HOME/standalone/deployments/kie-server-archive.war

# Database MySQL and PostgreSQL modules
ADD maven/modules/kie-wildfly-mysql-module.tar.gz $JBOSS_HOME/modules/system/layers/base
ADD maven/modules/kie-wildfly-postgres-module.tar.gz $JBOSS_HOME/modules/system/layers/base

# Work with unpacked WAR archives in WildFly, so other images can override webapp files (such as persistence.xml,etc)
RUN unzip -q -d $JBOSS_HOME/standalone/deployments/business-central.war $JBOSS_HOME/standalone/deployments/business-central-archive.war && \
touch $JBOSS_HOME/standalone/deployments/business-central.war.dodeploy && \
rm -rf $JBOSS_HOME/standalone/deployments/business-central-archive.war
RUN unzip -q -d $JBOSS_HOME/standalone/deployments/kie-server.war $JBOSS_HOME/standalone/deployments/kie-server-archive.war && \
touch $JBOSS_HOME/standalone/deployments/kie-server.war.dodeploy && \
rm -rf $JBOSS_HOME/standalone/deployments/kie-server-archive.war

# Set right permissions for jboss user.
RUN chown -R jboss:jboss $JBOSS_HOME/standalone/deployments/* && \
chmod +x $JBOSS_HOME/bin/*.sh && \
chown jboss:jboss $JBOSS_HOME/bin/start_business-central.sh && \
chown jboss:jboss $JBOSS_HOME/bin/update-jpa-config.sh && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/business-central-users.properties && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/business-central-roles.properties && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/standalone-full-business-central.xml && \
chown -R jboss:jboss $JBOSS_HOME/modules/system/layers/base/*
# Switchback to jboss user
USER jboss

####### EXPOSE INTERNAL BUSINESS_CENTRAL GIT PORT ############
EXPOSE 8001

####### COMMAND ############
WORKDIR $JBOSS_HOME/bin/
CMD ["./start_business-central.sh"]