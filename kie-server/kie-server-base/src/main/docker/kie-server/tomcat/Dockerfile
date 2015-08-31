####### BASE ############
FROM tomcat:7.0.61-jre7

####### MAINTAINER ############
MAINTAINER "Roger Martinez" "romartin@redhat.com"

####### ENVIRONMENT ############
ENV JAVA_OPTS -XX:MaxPermSize=256m -Xms256m -Xmx512m
ENV CATALINA_OPTS -Xmx512M -XX:MaxPermSize=512m -Dbtm.root=$CATALINA_HOME -Dbitronix.tm.configuration=$CATALINA_HOME/conf/btm-config.properties
LABEL org.kie.kie-server.artifact=${kie.docker.kie-server.tomcat7.repositoryPath}

####### KIE-SERVER & SITE WAR ############
ADD maven/kie-server.war $CATALINA_HOME/webapps/kie-server.war
ADD maven/site $CATALINA_HOME/webapps/site
RUN unzip -q -d $CATALINA_HOME/webapps/kie-server $CATALINA_HOME/webapps/kie-server.war && \
rm -rf $CATALINA_HOME/webapps/kie-server.war && \
unzip -q -d $CATALINA_HOME/webapps/site $CATALINA_HOME/webapps/site/kie-server-site.jar && \
rm -rf $CATALINA_HOME/webapps/site/kie-server-site.jar

####### TOMCAT EXTRA LIBRARIES ############
ADD maven/tomcat-libs/btm-2.1.4.jar $CATALINA_HOME/lib/btm-2.1.4.jar
ADD maven/tomcat-libs/btm-tomcat55-lifecycle-2.1.4.jar $CATALINA_HOME/lib/btm-tomcat55-lifecycle-2.1.4.jar
ADD maven/tomcat-libs/h2-1.3.161.jar $CATALINA_HOME/lib/h2-1.3.161.jar
ADD maven/tomcat-libs/jta-1.1.jar $CATALINA_HOME/lib/jta-1.1.jar
ADD maven/tomcat-libs/slf4j-api-1.7.12.jar $CATALINA_HOME/lib/slf4j-api-1.7.12.jar
ADD maven/tomcat-libs/javax.security.jacc-api-1.5.jar $CATALINA_HOME/lib/javax.security.jacc-api-1.5.jar
ADD maven/tomcat-libs/kie-tomcat-integration.jar $CATALINA_HOME/lib/kie-tomcat-integration.jar

####### TOMCAT CONF FILES ############
ADD etc/btm-config.properties  $CATALINA_HOME/conf/btm-config.properties
ADD etc/context.xml  $CATALINA_HOME/conf/context.xml
ADD etc/resources.properties $CATALINA_HOME/conf/resources.properties
ADD etc/server.xml  $CATALINA_HOME/conf/server.xml
ADD etc/tomcat-users.xml  $CATALINA_HOME/conf/tomcat-users.xml
ADD etc/start_kie-server.sh  $CATALINA_HOME/bin/start_kie-server.sh
RUN chmod +x $CATALINA_HOME/bin/*.sh

####### RUNNING KIE-SERVER ############
WORKDIR $CATALINA_HOME/bin
CMD ["./start_kie-server.sh"]