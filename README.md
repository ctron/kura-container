# Eclipse Kura™ emulator Docker image [![Docker Automated build](https://img.shields.io/docker/automated/ctron/kura-emulator.svg)](https://hub.docker.com/r/ctron/kura-emulator/)

This is a docker image running the Eclipse Kura™ emulator.

Use the following command to run it:

    docker run -ti -p 8080:8080 ctron/kura-emulator

Once the image is started you can navigate your browser to http://localhost:8080 and log in using the credentials `admin` : `admin`.

## Making use of Apache Felix File Install

This image includes [Apache Felix FileInstall](https://felix.apache.org/documentation/subprojects/apache-felix-file-install.html "Apache Felix File Install"),
which monitors a directory and loads all OSGi bundles it detects during runtime. Adding a new bundle is
as easy as dropping an OSGi JAR file into a directory. Uninstalling is done by deleting the file and updates
are simply done by overwriting the bundle with a newer version.

File Install loads bundles from `/opt/eclipse/kura/load` which is also defined as a docker volume,
so that you can link this up with your container host:

    docker run -ti -p 8080:8080 -v /home/user/path/to/bundles:/opt/eclipse/kura/load:z ctron/kura-emulator

Now you can access `/home/user/path/to/bundles` on your host machine and bundles will be loaded
by Kura inside the docker container.

**Note:** It may be that a bundle which is first installed needs to be manually started using the Kura Web UI.

## Running with JMX enabled

Running with JMX or debugging enabled can sometimes be quite helpful. However it is disabled by default. 

### On Linux

If you want to run the image with JMX enabled use the following command on Linux:

    docker run -ti -eJAVA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Xdebug -Xrunjdwp:transport=dt_socket,address=9011,server=y,suspend=n" -p 8080:8080 -p 9010:9010 -p 9011:9011 ctron/kura-emulator

### On Windows

If you want to run the image with JMX enabled use the following command on Windows: 

    docker run -ti -eJAVA_OPTS="-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=<IP> -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.rmi.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Xdebug -Xrunjdwp:transport=dt_socket,address=9011,server=y,suspend=n" -p 8080:8080 -p 9010:9010 -p 9011:9011 ctron/kura-emulator

Where *\<IP\>* is the Docker address, you can find it by using *ipconfig* and search for *DockerNAT* address, for instance:

    Ethernet adapter vEthernet (DockerNAT):
    Connection-specific DNS Suffix  . :
    IPv4 Address. . . . . . . . . . . : 10.0.75.1
    Subnet Mask . . . . . . . . . . . : 255.255.255.0
    Default Gateway . . . . . . . . . :
    
The JMX port defined is 9010 and the Remote debug port is 9011.

## Re-Building

This docker container is being built by patching Kura 3.0.0 in a way that is can be run inside
a docker image. For this to work, this docker build checks out a specific Kura commit, currently from
the 3.0.0 develop branch, so that the patch can be applied.

If you want to re-build this image, check out this repository and simply run `docker build .`.

If you want to re-base this image on another Kura commit, then you will need to change the environment
variable in the `Dockerfile` or from the command line. If the patch no longer applies, then you will
need to re-create or fix that patch.
