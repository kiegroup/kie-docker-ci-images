####### BASE ############
FROM ce-registry.usersys.redhat.com/jboss-eap-7-tech-preview/eap70:1.3

####### MAINTAINER ############
MAINTAINER "Michael Biarnes Kiefer" "mbiarnes@redhat.com"

####### LOCALE ############
ENV LANG en_US.UTF-8

####### ENVIRONMENT ############
ENV JAVA_OPTS -Xms512m -Xmx1024m
ENV JBOSS_BIND_ADDRESS 0.0.0.0
ENV KIE_CONNECTION_URL jdbc:h2:mem:test;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE
ENV KIE_CONNECTION_DRIVER h2
ENV KIE_CONNECTION_USER sa
ENV KIE_CONNECTION_PASSWORD sa
ENV KIE_CONNECTION_DATABASE kie
LABEL org.kie.kie-drools-wb.artifact=org.kie:kie-drools-wb:war:eap7

####### SYTEM USERS FOR DEVELOPMENT ############
USER root
# Set a password for root & jboss users (for any further system operations, etc)
RUN echo "root:rootman" | chpasswd && \
echo "jboss:jboss" | chpasswd

####### KIE-DROOLS-WB & EAP7 CONFIG FILES ############
# Latest WAR from Red Hat internal repository & Custom EAP 7 configuration files
# There is an issue in Docker with ADD command.
# When a file is added into the container's filesystem, the file owner is always root, instead of the current running user.
# See https://github.com/docker/docker/issues/5110
# The workaround is doing a chown using root user and then switchback to jboss user.
# WildFly custom configuration.
ADD etc/kie-drools-wb-users.properties $JBOSS_HOME/standalone/configuration/kie-drools-wb-users.properties
ADD etc/kie-drools-wb-roles.properties $JBOSS_HOME/standalone/configuration/kie-drools-wb-roles.properties
ADD etc/standalone-full-kie-drools-wb.xml $JBOSS_HOME/standalone/configuration/standalone-full-kie-drools-wb.xml
# Custom kie-drools-wb EAP startup scripts.
ADD etc/start_kie-drools-wb.sh $JBOSS_HOME/bin/start_kie-drools-wb.sh
ADD etc/update-jpa-config.sh $JBOSS_HOME/bin/update-jpa-config.sh
# Add the kie-drools-wb WAR artifact from the assembly result.
ADD maven/kie-drools-wb.war $JBOSS_HOME/standalone/deployments/kie-drools-wb-archive.war
# Database MySQL and PostgreSQL modules
ADD maven/modules/kie-eap-mysql-module.tar.gz $JBOSS_HOME/modules/system/layers/base
ADD maven/modules/kie-eap-postgres-module.tar.gz $JBOSS_HOME/modules/system/layers/base

# Work with unpacked WAR archives in EAP, so other images can override webapp files (such as persistence.xml,etc)
RUN unzip -q -d $JBOSS_HOME/standalone/deployments/kie-drools-wb.war $JBOSS_HOME/standalone/deployments/kie-drools-wb-archive.war && \
touch $JBOSS_HOME/standalone/deployments/kie-drools-wb.war.dodeploy && \
rm -rf $JBOSS_HOME/standalone/deployments/kie-drools-wb-archive.war && \
chown -R jboss:jboss $JBOSS_HOME/standalone/deployments/* && \
chmod +x $JBOSS_HOME/bin/*.sh && \
chown jboss:jboss $JBOSS_HOME/bin/start_kie-drools-wb.sh && \
chown jboss:jboss $JBOSS_HOME/bin/update-jpa-config.sh && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/kie-drools-wb-users.properties && \ 
chown jboss:jboss $JBOSS_HOME/standalone/configuration/kie-drools-wb-roles.properties && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/standalone-full-kie-drools-wb.xml && \
chown -R jboss:jboss $JBOSS_HOME/modules/system/layers/base/*
# Switchback to jboss user
USER jboss

####### EXPOSE INTERNAL KIE-DROOLS-WB GIT PORT ############
EXPOSE 8001

####### COMMAND ############
WORKDIR $JBOSS_HOME/bin/
CMD ["./start_kie-drools-wb.sh"]
