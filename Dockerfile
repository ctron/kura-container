FROM fedora:25
MAINTAINER Jens Reimann <jreimann@redhat.com>

ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0
ENV MAVEN_PROPS=-Dmaven.test.skip=true

RUN dnf -y install git java-1.8.0-openjdk-devel maven procps-ng zip unzip tar psmisc telnet dos2unix net-tools hostname
RUN git clone https://github.com/eclipse/kura.git -b develop

WORKDIR /kura
RUN mvn -f target-platform/pom.xml clean install $MAVEN_PROPS
RUN mvn -f kura/manifest_pom.xml clean install $MAVEN_PROPS -Pspeedup
COPY kura.patch /
RUN git apply --verbose ../kura.patch && mv kura/distrib/src/main/resources/fedora25 kura/distrib/src/main/resources/fedora25-nn
RUN mvn -f kura/distrib/pom.xml clean install $MAVEN_PROPS -Pfedora25
WORKDIR /

# RUN dnf remove -y git java-1.8.0-openjdk-devel maven && dnf install -y jre-1.8.0-openjdk-headless

RUN ./kura/kura/distrib/target/kura_3.0.0-SNAPSHOT_fedora25-nn_installer.sh

# RUN rm -Rf /kura /root/.m2 && dnf -y clean all

EXPOSE 8080

ENTRYPOINT ["/opt/eclipse/kura/bin/start_kura.sh"]


#RUN dnf -y install git java-1.8.0-openjdk-devel maven && \
#    git clone https://github.com/eclipse/kura.git -b develop && \
#    cd /kura && ./build-all.sh -Pspeedup -Pfedora25 && \
#    dnf remove -y git java-1.8.0-openjdk-devel maven && \
#    dnf install -y jre-1.8.0-openjdk-headless && \
#    rm -Rf /kura /root/.m2 && dnf -y clean all && \
#    ./kura/kura/deploy/target/kura_3.0.0-SNAPSHOT_fedora25_installer.sh

