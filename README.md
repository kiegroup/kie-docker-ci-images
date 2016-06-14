KIE Docker Images for Continuous integration and testing
========================================================

Introduction
------------

This project is used to achieve a lightweight continuous integration system for our daily development. It Dockerizes some KIE applications and runs them in a Docker containers.

Project's modules are:               
* `kie-jboss-modules` - Generates and assemblies the MySQL and PostgreSQL database modules for WildFly               
* `kie-wb` - Builds and runs the `KIE Workbench` Docker image with latest build from master branch.
* `kie-drools-wb` - Builds and runs the `KIE Drools Workbench` Docker image with latest build from master branch.
* `kie-server` - Builds and runs the `KIE Execution Server` Docker image with latest build from master branch.
* `uf-dashbuilder` - Builds and runs the `UF Dashbuilder` Docker image with latest build from master branch.
* `kie-artifacts` - Deploy all the Maven artifacts used for all the previous applications into an specified local filesystem path, were they can be later consumed

The integration between Maven and Docker is done using the `docker-maven-plugin` that you can find at [GitHub](https://github.com/rhuss/docker-maven-plugin).                               

KIE Docker images considerations
--------------------------------

The `KIE Workbench`, `KIE Drools Workbench`, `KIE Execution Server` and `UF Dashbuilder` modules are used to build the Docker image for each application.                   

**IMPORTANT NOTE**                     
This images are quite different from the official community ones, that you can find at:                   
* [jBPM Workbench](https://registry.hub.docker.com/u/jboss/jbpm-workbench/)                      
* [jBPM Workbench Showcase](https://registry.hub.docker.com/u/jboss/jbpm-workbench-showcase/)                        
* [Drools Workbench](https://registry.hub.docker.com/u/jboss/drools-workbench/)                      
* [Drools Workbench Showcase](https://registry.hub.docker.com/u/jboss/drools-workbench-showcase/)                      
* [KIE Execution Server](https://registry.hub.docker.com/u/jboss/kie-server/)                      
* [KIE Execution Server Showcase](https://registry.hub.docker.com/u/jboss/kie-server-showcase/)                      

The images from this project are more complex and intended for achieving continuous integration testing purposes, so they have additional features (not included in the community ones) such as:                   
* They use latest CI builds for all KIE applications, instead of using official `Final` releases
* There exist a Docker image for each KIE application that runs on WildFly 10 and Tomcat 8
* Support for external MySQL and PostgreSQL databases                      
* The web applications for the images are deployed as exploded war files by default
* Each image contains helper scripts to achieve the different application servers and databases supported with just using Docker command line environment variables                            
* Shell `root` access                                        

So having in mind all these previous considerations, if just want to run/try any KIE application it's recommended to use the official community ones presented above. This images are more complex and uses latest SNAPSHOT versions for building the images, so images can not be stable at all.                    

Build process
-------------

The build process for this project consist of the following steps:                 
* Build database WildFly modules artifacts that will be used for the next Docker images builds (module = `kie-jboss-modules`)                           
* For each project's sub-module (`KIE Workbench`, `KIE Drools Workbench`, `KIE Execution Server`, `UF Dashbuilder`)               
    * Create Docker images for `KIE Workbench`, `KIE Drools Workbench`, `KIE Execution Server` and `UF Dashbuilder` using latest SNAPSHOT versions from both `master` and `product` branches                                  
    * Push the images into the Docker registry (this step is currently disabled)                                    
    * Run a Docker container the each recently creaated image                    
* Deploy the recently Maven artifacts used for the build into a local filesystem directory (for further consuming)                     
* Create the Docker image for the KIE Docker UI web application used for handling all docker images stuff by common web interface and runs a containers for that image                        

Maven Properties used for the build
-----------------------------------

The following Maven properties can be specified for customizing the Maven build endpoints, versions, etc:                                 

* `docker.daemon.rest.url` - The URL for the Docker daemon REST API. Defaults to `http://localhost:2375`.                                  
* `docker.registry` - The URL for the docker registry, if push is enabled on build (currently disabled). Defaults to `localhost:5000`.                                  
* `docker.kie.repository` - The repository name for the generated images. Defaults to `jboss-kie`.                                  
* `kie.artifacts.deploy.path` - The target local path on filesystem where artifacts used in the build process will be deployed. Defaults to `/tmp/kie-artifacts`.

Usage
-----

Some **Maven profiles** are available for customizing the build process:                       
* `all` - Activated by default and using system property `all`. This profile includes all the project's submodules.                        
* `kie-wb` - Activated using system property `kie-wb`. This profile includes only the build for `kie-jboss-modules` and `kie-wb`.                     
* `kie-drools-wb` - Activated using system property `kie-drools-wb`. This profile includes only the build for `kie-jboss-modules` and `kie-drools-wb`.                     
* `kie-server` - Activated using system property `kie-server`. This profile includes only the build for `kie-jboss-modules` and `kie-server`.                     
* `uf-dashbuilder` - Activated using system property `uf-dashbuilder`. This profile includes only the build for `kie-jboss-modules` and `uf-dashbuilder`.                     
* `kie-artifacts` - Activated using system property `kie-artifacts`. This profile includes only the build for `kie-artifacts`.

You can run the complete build using:                    

    mvn clean install -DskipTests
    
You can run the build only for KIE Workbench using:                    

    mvn clean install -P !all,kie-wb

You can run the build only for KIE Drools Workbench using:                    

    mvn clean install -P !all,kie-drools-wb

You can run the build only for KIE Execution Server using:                    

    mvn clean install -P !all,kie-server

You can run the build only for UF Dashbuilder using:                    

    mvn clean install -P !all,uf-dashbuilder

You can run the build only for deploying KIE Maven artifacts using:                    

    mvn clean install -P !all,kie-artifacts

NOTE: There exist some helper scripts to perform common maintenance tasks and run more complex builds located at  source folder `/scripts'. Feel free to take a look at them.

Notes
-----

* This project is being used for Red Hat internal integration testing, so no security or high performance considerations have been applied. It's just a proof of concept to try to facilitate, automate and use a mechanism for our daily integration environment.                               
* This continuous integration system is not designed to provide any kind of Docker orchestration mechanism or any Docker web application generic manager or stuff like that... it just provides an easy and automated way to integrate our Maven builds with Docker to achieve a basic CI mechanism for our daily development. If you are looking for a deep control of Docker management and orchestration features we recommend taking a look at [OpenShift](https://github.com/openshift/origin/) or [Kubernetes](http://kubernetes.io/).                 
* This system has been developed and tested against a Docker installation for version `Docker version 1.6.2, build ba1f6c3/1.6.2` in a Red Hat Enterprise Linux version 7                       
