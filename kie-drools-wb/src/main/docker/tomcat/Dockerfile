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
LABEL org.kie.kie-drools-wb.artifact=org.kie:kie-drools-wb-distribution-wars:war:tomcat7

####### KIE-DROOLS-WB WAR ############
ADD maven/kie-drools-wb.war $CATALINA_HOME/webapps/kie-drools-wb.war

RUN unzip -q -d $CATALINA_HOME/webapps/kie-drools-wb $CATALINA_HOME/webapps/kie-drools-wb.war && \
rm -rf $CATALINA_HOME/webapps/kie-drools-wb.war

####### TOMCAT EXTRA LIBRARIES ############
ADD maven/tomcat-libs $CATALINA_HOME/lib/

####### TOMCAT CONF FILES ############
ADD etc/btm-config.properties  $CATALINA_HOME/conf/btm-config.properties
ADD etc/context.xml  $CATALINA_HOME/conf/context.xml
ADD etc/resources.properties.template  $CATALINA_HOME/conf/resources.properties.template
ADD etc/server.xml  $CATALINA_HOME/conf/server.xml
ADD etc/tomcat-users.xml  $CATALINA_HOME/conf/tomcat-users.xml
ADD etc/start_kie-drools-wb.sh  $CATALINA_HOME/bin/start_kie-drools-wb.sh
ADD etc/update-jpa-config.sh  $CATALINA_HOME/bin/update-jpa-config.sh
RUN chmod +x $CATALINA_HOME/bin/*.sh

####### EXPOSE INTERNAL KIE-DROOLS-WB GIT PORT ############
EXPOSE 8001

####### RUNNING KIE_DROOLS-WB ############
WORKDIR $CATALINA_HOME/bin
CMD ["./start_kie-drools-wb.sh"]