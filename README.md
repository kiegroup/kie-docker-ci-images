KIE Docker Images for Continuous integration and testing
========================================================

Introduction
------------

This project is used to achieve a lightweight continuous integration system for our daily development. It Dockerizes some KIE applications and runs them in a Docker containers.

Project's modules are:               
* `kie-jboss-modules` - Generates and assemblies the MySQL and PostgreSQL database modules for WildFly
* `business-central` - Builds and runs the `Business Central` Docker image with latest build from master branch.
* `kie-server` - Builds and runs the `KIE Execution Server` Docker image with latest build from master branch.
* `kie-artifacts` - Deploy all the Maven artifacts used for all the previous applications into an specified local filesystem path, were they can be later consumed

The integration between Maven and Docker is done using the `docker-maven-plugin` that you can find at [GitHub](https://github.com/rhuss/docker-maven-plugin).                               

KIE Docker images considerations
--------------------------------

The `Business-Central Workbench`, `KIE Server Workbench`, `JBPM Server Full` modules are used to build the Docker image for each application.

**IMPORTANT NOTE**                     
This images are quite different from the official community ones, that you can find at:                   
* [Business Central Workbench](https://quay.io/repository/kiegroup/business-central-workbench)                      
* [Business Central Workbench Showcase](https://quay.io/repository/kiegroup/business-central-workbench-showcase)                        
* [KIE Server](https://quay.io/repository/kiegroup/kie-server)                      
* [Kie Server Showcase](https://quay.io/repository/kiegroup/kie-server-showcase)                      
* [JBPM Server Full](https://quay.io/repository/kiegroup/jbpm-server-full)                       

The images from this project are more complex and intended for achieving continuous integration testing purposes, so they have additional features (not included in the community ones) such as:                   
* They use latest CI builds for all KIE applications, instead of using official `Final` releases
* There exist a Docker image for each KIE application that runs on WildFly 23
* Support for external MySQL and PostgreSQL databases                      
* The web applications for the images are deployed as exploded war files by default
* Each image contains helper scripts to achieve the different application servers and databases supported with just using Docker command line environment variables                            
* Shell `root` access                                        

So having in mind all these previous considerations, if just want to run/try any KIE application it's recommended to use the official community ones presented above. This images are more complex and uses latest SNAPSHOT versions for building the images, so images can not be stable at all.                    

Build process
-------------

The build process for this project consist of the following steps:                 
* Build database WildFly modules artifacts that will be used for the next Docker images builds (module = `kie-jboss-modules`)                           
* For each project's sub-module (`Business Central Workbench Showcase`, `KIE Server`)
    * Create Docker images for `Business Central Workbench Showcase`, `KIE Server` using latest SNAPSHOT versions from both `main` and `product` branches     
    * Run a Docker container for each recently created image                    
* Deploy the recently Maven artifacts used for the build into a local filesystem directory (for further consuming)                     
* Create the Docker image for the KIE Docker UI web application used for handling all docker images stuff by common web interface and runs a containers for that image                        

Maven Properties used for the build
-----------------------------------

The following Maven properties can be specified for customizing the Maven build endpoints, versions, etc:                                 

* `docker.daemon.rest.url` - The URL for the Docker daemon REST API. Defaults to `http://localhost:2375`.                                  
* `docker.registry` - The URL for the docker registry, if push is enabled on build (currently disabled). Defaults to `localhost:5000`.                                  
* `docker.kie.repository` - The repository name for the generated images. Defaults to `kiegroup`.                                  
* `kie.artifacts.deploy.path` - The target local path on filesystem where artifacts used in the build process will be deployed. Defaults to `/tmp/kie-artifacts`.

Usage
-----

Some **Maven profiles** are available for customizing the build process:                       
* `all` - Activated by default and using system property `all`. This profile includes all the project's submodules.                        
* `kie-wb` - Activated using system property `kie-wb`. This profile includes only the build for `kie-jboss-modules` and `kie-wb`.                     
* `kie-server` - Activated using system property `kie-server`. This profile includes only the build for `kie-jboss-modules` and `kie-server`.
* `kie-artifacts` - Activated using system property `kie-artifacts`. This profile includes only the build for `kie-artifacts`.

You can run the complete build using:                    

    mvn clean install -DskipTests
    
You can run the build only for KIE Workbench using:                    

    mvn clean install -P !all,kie-wb

You can run the build only for Business Central using:

    mvn clean install -P !all,business-central

You can run the build only for KIE Execution Server using:                    

    mvn clean install -P !all,kie-server

You can run the build only for deploying KIE Maven artifacts using:

    mvn clean install -P !all,kie-artifacts

BUILD and RUN the Docker images: 

    mvn clean install -DskipTests

  This will create two images:
* kiegroup/business-central-wildfly23
* kiegroup/kie-server-wildfly23

The mvn clean install creates two images as well as it runs them

  This command gets the IDs of all running containers
  
    docker ps -a

  This command inspects a running container and extracts his {IP address}

    docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id

  Now having the IP address you can access

  **kie-server**:       http://{IP address}:8080/kie-server/services/rest/server/ (login kie-server/kie-server)<br>
  When you access **kie-server** you only get shown a xml.<br>
  For more information about the [KIE Server](https://docs.jbpm.org/7.61.0.Final/jbpm-docs/html_single/#_ch.kie.server)
  
  **business central**: http://{IP address}:8080/business-central/ (login wbadmin/wbadmin) 

  With this command you can run your own container:

    docker run -p 8082:8080 -p 8002:8001 -i -t --name <name> <imageName>:<tag>
    i.e. docker run -p 8082:8080 -p 8002:8001 -i -t --name business-central kiegroup/business-central-wildfly23:7.63.0-SNAPSHOT

  You can access the application in a browser: http://localhost:8082/business-central and login using wbadmin/wbadmin

Stop and remove containers and images
  
    docker stop $(docker ps -aq)    - stops **all** running container (or docker stop containerID)
    docker rm $(docker ps -aq)      - removes **all** containers (or docker rm containerID)
    docker rmi $(docker images -aq) - rmoves **all** images (or docker rmi imageID)


NOTE: There exist some helper scripts to perform common maintenance tasks and run more complex builds located at  source folder `/scripts'. Feel free to take a look at them.

Notes
-----

* This project is being used for Red Hat internal integration testing, so no security or high performance considerations have been applied. It's just a proof of concept to try to facilitate, automate and use a mechanism for our daily integration environment.                               
* This continuous integration system is not designed to provide any kind of Docker orchestration mechanism or any Docker web application generic manager or stuff like that... it just provides an easy and automated way to integrate our Maven builds with Docker to achieve a basic CI mechanism for our daily development. If you are looking for a deep control of Docker management and orchestration features we recommend taking a look at [OpenShift](https://github.com/openshift/origin/) or [Kubernetes](http://kubernetes.io/).                 
* This system has been developed and tested against a Docker installation for version `Docker version 20.10.9, build c2ea9bc` in a Red Hat Enterprise Linux version 7                       
