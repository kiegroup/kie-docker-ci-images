####### BASE ############
FROM tomcat:8.0.30-jre8

####### MAINTAINER ############
MAINTAINER "Roger Martinez" "romartin@redhat.com"

####### LOCALE ############
ENV LANG en_US.UTF-8

####### ENVIRONMENT ############
ENV JAVA_OPTS -Xms256m -Xmx512m
ENV CATALINA_OPTS -Xmx512M -Dbtm.root=$CATALINA_HOME -Dbitronix.tm.configuration=$CATALINA_HOME/conf/btm-config.properties -Djava.security.egd=file:/dev/./urandom
ENV KIE_CONNECTION_URL jdbc:h2:file:~/jbpm
ENV KIE_CONNECTION_DRIVER h2
ENV KIE_CONNECTION_USER sa
# Empty password by default
# ENV KIE_CONNECTION_PASSWORD 
ENV KIE_CONNECTION_DATABASE kie
LABEL org.dashbuilder.artifact=org.dashbuilder:dashbuilder-distros:war:tomcat8

####### DASHBUILDER WAR ############
ADD maven/dashbuilder.war $CATALINA_HOME/webapps/dashbuilder.war

RUN unzip -q -d $CATALINA_HOME/webapps/dashbuilder $CATALINA_HOME/webapps/dashbuilder.war && \
rm -rf $CATALINA_HOME/webapps/dashbuilder.war

####### TOMCAT EXTRA LIBRARIES ############
ADD maven/tomcat-libs $CATALINA_HOME/lib/

####### TOMCAT CONF FILES ############
ADD etc/btm-config.properties  $CATALINA_HOME/conf/btm-config.properties
ADD etc/context.xml  $CATALINA_HOME/conf/context.xml
ADD etc/resources.properties.template  $CATALINA_HOME/conf/resources.properties.template
ADD etc/server.xml  $CATALINA_HOME/conf/server.xml
ADD etc/tomcat-users.xml  $CATALINA_HOME/conf/tomcat-users.xml
ADD etc/start_dashbuilder.sh  $CATALINA_HOME/bin/start_dashbuilder.sh
RUN chmod +x $CATALINA_HOME/bin/*.sh

####### EXPOSE INTERNAL DASHBUILDER GIT PORT ############
# Dashbuilder still does not support interval VFS, not needed yet.
# EXPOSE 8001

####### RUNNING DASHBUILDER ############
WORKDIR $CATALINA_HOME/bin
CMD ["./start_dashbuilder.sh"]