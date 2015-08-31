####### BASE ############
FROM tomcat:7.0.61-jre7

####### MAINTAINER ############
MAINTAINER "Roger Martinez" "romartin@redhat.com"

####### ENVIRONMENT ############
ENV JAVA_OPTS -XX:MaxPermSize=256m -Xms256m -Xmx512m
ENV CATALINA_OPTS -Xmx512M -XX:MaxPermSize=256m
ENV KIE_DOCKER_SERVER_PRIVATE 172.17.42.1
ENV KIE_DOCKER_SERVER_PUBLIC kieci01-docker.lab.eng.brq.redhat.com
# ENV KIE_DOCKER_ARTIFACTS_PATH
ENV KIE_DOCKER_JENKINS_URL https://brms-jenkins.rhev-ci-vms.eng.rdu2.redhat.com/job/kie-docker-images/

####### WEBAPP ############
ADD maven/kie-docker-ui-webapp.war $CATALINA_HOME/webapps/kie-docker-ui-webapp.war
RUN unzip -q -d $CATALINA_HOME/webapps/kie-docker-ui-webapp $CATALINA_HOME/webapps/kie-docker-ui-webapp.war && \
rm -rf $CATALINA_HOME/webapps/kie-docker-ui-webapp.war

###### START SCRIPT #########
ADD start_kie-docker-ui.sh $CATALINA_HOME/bin/start_kie-docker-ui.sh

####### RUNNING KIE DOCKER UI ############
WORKDIR $CATALINA_HOME/bin
CMD ["./start_kie-docker-ui.sh"]