FROM ctron/kura:develop

MAINTAINER Jens Reimann <jreimann@redhat.com>
LABEL maintainer "Jens Reimann <jreimann@redhat.com>"

RUN \
    yum -y install gdb && \
    debuginfo-install java-1.8.0-openjdk-headless
