# Eclipse Kura™ emulator Docker image [![Docker Automated build](https://img.shields.io/docker/automated/ctron/kura-emulator.svg)](https://hub.docker.com/r/ctron/kura-emulator/)

This is a docker image running the Eclipse Kura™ emulator.

Use the following command to run it:

    docker run -ti -p 8080:8080 ctron/kura-emulator

Once the image is started you can navigate your browser to http://localhost:8080 and log in using the credentials `admin` : `admin`.

## Running with JMX enabled

If you want to run the image with JMX enabled use the following command on Linux:

    docker run -ti -eJAVA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false" -p 8080:8080 -p 9010:9010 ctron/kura-emulator
    
If you want to run the image with JMX enabled use the following command on Windows: 

    docker run -ti -eJAVA_OPTS="-Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=<IP> -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.rmi.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false" -p 8080:8080 -p 9010:9010 ctron/kura-emulator

Where *\<IP\>* is the Docker address, you can find it by using *ipconfig* and search for *DockerNAT* address, for instance:

    Ethernet adapter vEthernet (DockerNAT):
    Connection-specific DNS Suffix  . :
    IPv4 Address. . . . . . . . . . . : 10.0.75.1
    Subnet Mask . . . . . . . . . . . : 255.255.255.0
    Default Gateway . . . . . . . . . :
    
