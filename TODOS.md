TODOS
=====

**Git repositories**           
* Create git branches in repo for each branch to build (master, 6.3.x and 6.2.x)           
* Clean "old" kie-docker-ci           

**Maven modules**           
* Refactor kie-artifacts? each module should copy the artifacts to the target location.. this will allow modules to build independently           

**Issues**           
* kie-wb master using wildfly do not start.           
* kie-drools-wb using wildfly master do not start.           
* build.sh script - error handling -> throw errors so that Jenkins can mark the job as failed            
        
        Eg: If Jenkins job fails (eg: timeout) , the build script execution continues on the target server.
        Eg: If mvn build fails -> job marked as correct

**Webapp (kie-docker-ui)**           
* Separate in different jenkins jobs -> webapp not restarted on each build. refactor it           
* Add rest services for checking current docker containers status, when builds runs.            
* Move to port 80 and root context           
* favicon           
* icon for KIE Execution Server           

**Server issues**           
* Review Firewall is open for docker container's ports (ssh connections)           