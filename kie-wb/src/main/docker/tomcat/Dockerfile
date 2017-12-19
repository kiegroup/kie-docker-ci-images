####### BASE ############
FROM tomcat:8.0.30-jre8

####### MAINTAINER ############
MAINTAINER "Roger Martinez" "romartin@redhat.com"

####### LOCALE ############
ENV LANG en_US.UTF-8

####### ENVIRONMENT ############
ENV JAVA_OPTS -XX:MaxPermSize=256m -Xms256m -Xmx512m
ENV CATALINA_OPTS -Xmx512M -XX:MaxPermSize=512m -Dbtm.root=$CATALINA_HOME -Dbitronix.tm.configuration=$CATALINA_HOME/conf/btm-config.properties -Djava.security.egd=file:/dev/./urandom \
 -Dorg.kie.server.id=test-kie-server -Dorg.kie.server.controller=http://localhost:8080/kie-wb/rest/controller -Dorg.kie.server.location=http://localhost:8080/kie-server/services/rest/server \
 -Djbpm.tsr.jndi.lookup=java:comp/env/TransactionSynchronizationRegistry -Dorg.kie.server.persistence.ds=java:comp/env/jdbc/jbpm -Djbpm.tm.jndi.lookup=java:comp/env/TransactionManager \
 -Dorg.kie.server.persistence.tm=JBossTS -Dhibernate.connection.release_mode=after_transaction \
 -Dorg.jbpm.ht.admin.user=wbadmin -Dorg.jbpm.ht.admin.group=admin
ENV KIE_CONNECTION_URL jdbc:h2:file:~/jbpm
ENV KIE_CONNECTION_DRIVER h2
ENV KIE_CONNECTION_USER sa
# Empty password by default
# ENV KIE_CONNECTION_PASSWORD 
ENV KIE_CONNECTION_DATABASE kie
LABEL org.kie.kie-wb.artifact=org.kie:kie-wb:war:tomcat8

####### KIE-WB WAR ############
ADD maven/kie-wb.war $CATALINA_HOME/webapps/kie-wb.war

RUN unzip -q -d $CATALINA_HOME/webapps/kie-wb $CATALINA_HOME/webapps/kie-wb.war && \
rm -rf $CATALINA_HOME/webapps/kie-wb.war

# Add the kie-server WAR artifact from the assembly result.
ADD maven/kie-server.war $CATALINA_HOME/webapps/kie-server-archive.war

RUN unzip -q -d $CATALINA_HOME/webapps/kie-server $CATALINA_HOME/webapps/kie-server-archive.war && \
rm -rf $CATALINA_HOME/webapps/kie-server-archive.war

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