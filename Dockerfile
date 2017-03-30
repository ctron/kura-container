FROM fedora:25

MAINTAINER Jens Reimann <jreimann@redhat.com>
LABEL maintainer "Jens Reimann <jreimann@redhat.com>"

ENV \
  JAVA_HOME=/usr/lib/jvm/jre-1.8.0 \
  MAVEN_PROPS=-DskipTests \
  KURA_COMMIT=e47ab6ee82cbc31be299e693feb3f9b5288372c5

COPY kura.patch /

RUN dnf -y update && dnf -y install git java-1.8.0-openjdk-devel maven procps-ng zip unzip tar psmisc telnet dos2unix net-tools hostname && \
    git clone https://github.com/eclipse/kura.git && cd kura && git checkout $KURA_COMMIT && \
    ( \
      cd /kura && \
      mvn -B -f target-platform/pom.xml clean install $MAVEN_PROPS -Dequinox.download.url=http://dentrassi.de/download/eclipse/equinox-SDK-Neon.1.zip && \
      mvn -B -f kura/manifest_pom.xml clean install $MAVEN_PROPS -Pspeedup && \
      git apply --verbose /kura.patch && \
      mv kura/distrib/src/main/resources/fedora25 kura/distrib/src/main/resources/fedora25-nn && \
      mvn -B -f kura/distrib/pom.xml clean install $MAVEN_PROPS -Pfedora25 -nsu \
    ) && \
    /kura/kura/distrib/target/kura_3.0.0-SNAPSHOT_fedora25-nn_installer.sh && \
    dnf remove -y git java-1.8.0-openjdk-devel maven && \
    dnf install -y jre-1.8.0-openjdk-headless && \
    rm -Rf /kura /root/.m2 /kura.patch && dnf -y clean all && \
    mkdir -p /opt/eclipse/kura/kura/packages && \
    cd /opt/eclipse/kura/kura/packages && \
    curl -O  https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.utils.fileinstall/0.2.2/de.dentrassi.kura.addons.utils.fileinstall-0.2.2.dp && \
    echo "de.dentrassi.kura.addons.utils.fileinstall=file\:/opt/eclipse/kura/kura/packages/de.dentrassi.kura.addons.utils.fileinstall-0.2.2.dp" > /opt/eclipse/kura/kura/dpa.properties && \
    echo "felix.fileinstall.disableNio2=true" >> /opt/eclipse/kura/kura/config.ini && \
    mkdir /opt/eclipse/kura/load

EXPOSE 8080

VOLUME ["/opt/eclipse/kura/load"]

ENTRYPOINT ["/opt/eclipse/kura/bin/start_kura.sh"]
