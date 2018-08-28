FROM ctron/kura-emulator:latest

MAINTAINER Jens Reimann <jreimann@redhat.com>
LABEL maintainer "Jens Reimann <jreimann@redhat.com>"

#
# First we copy over our custom configuration
# Then we also update the backup in ".data" and
# change permissions for OpenShift
#

COPY snapshot_0.xml /opt/eclipse/kura/data/snapshots/snapshot_0.xml

RUN \
    unpack-kura && \
    cp /opt/eclipse/kura/data/snapshots/snapshot_0.xml /opt/eclipse/kura/.data/snapshot_0.xml && \
    chmod a=rw /opt/eclipse/kura/data/snapshots/snapshot_0.xml /opt/eclipse/kura/.data/snapshot_0.xml && \
    dp-install "https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.artemis.server/0.3.0/de.dentrassi.kura.addons.artemis.server-0.3.0.dp" \
    pack-kura

EXPOSE 5672 1883
