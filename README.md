# Eclipse Kura™ container image [![Docker Automated build](https://img.shields.io/docker/automated/ctron/kura.svg)](https://hub.docker.com/r/ctron/kura/)

This is a container image running Eclipse Kura™.

Use the following command to run it:

    docker run -p 8080:8080 ctron/kura

Once the image is started you can navigate your browser to http://localhost:8080 and log in using the credentials `admin` : `admin`.

**Note:** The Git repository is now [ctron/kura-container](https://github.com/ctron/kura-container) and the Docker repository [ctron/kura](https://hub.docker.com/r/ctron/kura). 

## Enabling the interactive console

By default the Kura instance will run without an Equinox console on the TTY. You can enable the interactive console by passing the argument `-console` to the container, be sure to also enable the interactive TTY support for the container:

    docker run -ti -p 8080:8080 ctron/kura -console

## Different tags/branches

The container image is provided in different branches:

| Branch              | Description |
|---------------------|-------------|
| `develop`          | Points to some commit in the current development branch of Kura. |
| `latest` (default) | Points to the latest released version of Kura |
| `x.y.z`            | Points to a specific release of Kura. |

Also see: https://hub.docker.com/r/ctron/kura/tags

## Making use of Apache Felix File Install

This image includes [Apache Felix FileInstall](https://felix.apache.org/documentation/subprojects/apache-felix-file-install.html "Apache Felix FileInstall"), which monitors a directory and loads all OSGi bundles it detects during runtime. Adding a new bundle is as easy as dropping an OSGi JAR file into a directory. Uninstalling is done by deleting the file and updates are simply done by overwriting the bundle with a newer version.

File Install loads bundles from `/load` which is also defined as a docker volume, so that you can link this up with your container host:

    docker run -ti -p 8080:8080 -v /home/user/path/to/bundles:/load:z ctron/kura

Now you can access `/home/user/path/to/bundles` on your host machine and bundles will be loaded by Kura inside the docker container.

**Note:** It may be that a bundle, which is first installed, needs to be manually started using the Kura Web UI.

## Running with JMX enabled

Running with JMX or debugging enabled can sometimes be quite helpful. However it is disabled by default. 

### On Linux

If you want to run the image with JMX enabled use the following command on Linux:

    docker run -ti -eJAVA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Xdebug -Xrunjdwp:transport=dt_socket,address=9011,server=y,suspend=n" -p 8080:8080 --expose 9010 --expose 9011 -p 9010:9010 -p 9011:9011 ctron/kura

### On Windows

If you want to run the image with JMX enabled use the following command on Windows: 

    docker run -ti -eJAVA_OPTS="-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=<IP> -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.rmi.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Xdebug -Xrunjdwp:transport=dt_socket,address=9011,server=y,suspend=n" -p 8080:8080 --expose 9010 --expose 9011 -p 9010:9010 -p 9011:9011 ctron/kura

Where *<IP>* is the Docker address, you can find it by using *ipconfig* and search for *DockerNAT* address, for instance:

    Ethernet adapter vEthernet (DockerNAT):
    Connection-specific DNS Suffix  . :
    IPv4 Address. . . . . . . . . . . : 10.0.75.1
    Subnet Mask . . . . . . . . . . . : 255.255.255.0
    Default Gateway . . . . . . . . . :
    
The JMX port defined is 9010 and the Remote debug port is 9011. Both ports are not exposed by default and have to be exposed from the command line using `--expose 9010 --expose 9011`.

## Re-Building

This docker container is being built by re-using the Intel UP² CentOS 7 image of Kura. It temporarily sets up the container for building a specific Git commit of Kura and then removes all development dependencies, installing and configuring Kura to run insider a container. This allows you to pick a specific Kura commit, or re-build everything from your forked Git repository.

If you want to re-build the image, check out this repository and simply run `docker build .` on the command line.

You can also build a different commit of Kura by changing the environment variable `KURA_COMMIT` for the build. This can be changed in the `Dockerfile` itself, or e.g. using OpenShift source-to-image in the build configuration.

### Packed build

The build also allows you to set the environment variable `PACKED` to `true`, in which case the build will pack the installed version of Kura and delete it from the image before finishing the build. The start scripts will detect this and unpack the Kura instance before commencing with the actual startup. This can be used to create persistent instance containers, which only take the Kura from the container image for the first start. All following starts will use the unpacked Kura binaries. This allows you to upgrade the instance using the Kura upgrade flow, and make the changes of the update persistent as well. See the [OpenShift deployment](openshift/README.md) for more information about this use case.

## Running in OpenShift / OKD

There also is an [OpenShift template](openshift/README.md), which can be used to deploy this image into [OpenShift](https://www.okd.io/). This deplyoment allows you to run the image in either emphermal, data persistence or instance persistence mode. Read more at: [openshift/README.md](openshift/README.md)

## Building extended images

If you want to add additional content to the Kura installation inside the container image, it is possible to extend the installation.

See [extensions/camel-additions](extensions/camel-additions) for an example.
