####### BASE ############
FROM tomcat:8.0.30-jre8

####### MAINTAINER ############
MAINTAINER "Roger Martinez" "romartin@redhat.com"

####### ENVIRONMENT ############
ENV JAVA_OPTS -XX:MaxPermSize=256m -Xms256m -Xmx512m
ENV CATALINA_OPTS -Xmx512M -XX:MaxPermSize=512m -Dbtm.root=$CATALINA_HOME -Dbitronix.tm.configuration=$CATALINA_HOME/conf/btm-config.properties -Djava.security.egd=file:/dev/./urandom
ENV KIE_CONNECTION_URL jdbc:h2:file:~/jbpm
ENV KIE_CONNECTION_DRIVER h2
ENV KIE_CONNECTION_USER sa
# Empty password by default
# ENV KIE_CONNECTION_PASSWORD 
ENV KIE_CONNECTION_DATABASE kie
LABEL org.kie.kie-wb.artifact=org.kie:kie-wb-distribution-wars:war:tomcat7
LABEL org.jbpm.jbpm-dashboard.artifact=org.jbpm.dashboard:jbpm-dashboard-distributions:war:tomcat7

####### KIE-WB & DASHBOARD BUILDER WAR ############
ADD maven/kie-wb.war $CATALINA_HOME/webapps/kie-wb.war
ADD maven/dashbuilder.war $CATALINA_HOME/webapps/dashbuilder.war

RUN unzip -q -d $CATALINA_HOME/webapps/kie-wb $CATALINA_HOME/webapps/kie-wb.war && \
rm -rf $CATALINA_HOME/webapps/kie-wb.war && \
unzip -q -d $CATALINA_HOME/webapps/dashbuilder $CATALINA_HOME/webapps/dashbuilder.war && \
rm -rf $CATALINA_HOME/webapps/dashbuilder.war

####### TOMCAT EXTRA LIBRARIES ############
ADD maven/tomcat-libs $CATALINA_HOME/lib/

####### TOMCAT CONF FILES ############
ADD etc/btm-config.properties  $CATALINA_HOME/conf/btm-config.properties
ADD etc/context.xml  $CATALINA_HOME/conf/context.xml
ADD etc/resources.properties.template  $CATALINA_HOME/conf/resources.properties.template
ADD etc/server.xml  $CATALINA_HOME/conf/server.xml
ADD etc/tomcat-users.xml  $CATALINA_HOME/conf/tomcat-users.xml
ADD etc/start_kie-wb.sh  $CATALINA_HOME/bin/start_kie-wb.sh
ADD etc/update-jpa-config.sh  $CATALINA_HOME/bin/update-jpa-config.sh
RUN chmod +x $CATALINA_HOME/bin/*.sh

####### EXPOSE INTERNAL KIE-WB GIT PORT ############
EXPOSE 8001

####### RUNNING KIE-WB ############
WORKDIR $CATALINA_HOME/bin
CMD ["./start_kie-wb.sh"]