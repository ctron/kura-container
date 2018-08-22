FROM centos:7

MAINTAINER Jens Reimann <jreimann@redhat.com>
LABEL maintainer="Jens Reimann <jreimann@redhat.com>" \
      io.k8s.description="Containerized version of the Eclipse Kura™ IoT gateway" \
      io.openshift.non-scalable=true

ENV \
  GIT_REPO=https://github.com/eclipse/kura.git \
  GIT_BRANCH=develop \
  JAVA_HOME=/usr/lib/jvm/jre-1.8.0 \
  MAVEN_PROPS=-DskipTests \
  KURA_COMMIT=24efd0dffe1ca0a816d8da2832223c62e961fc7a

RUN yum -y update && \
    yum -y install scl-utils scl-utils-build centos-release-scl && \
    yum -y install git java-1.8.0-openjdk-devel rh-maven35 && \
    git clone "$GIT_REPO" -b "$GIT_BRANCH" && cd kura && git checkout $KURA_COMMIT && \
    ( \
      cd /kura && \
      `# Replace broken 'nn' script` \
      cp kura/distrib/src/main/sh/extract.sh kura/distrib/src/main/sh/extract_nn.sh && \
      scl enable rh-maven35 "mvn -B -f target-platform/pom.xml clean install $MAVEN_PROPS" && \
      scl enable rh-maven35 "mvn -B -f kura/pom.xml clean install $MAVEN_PROPS -Pspeedup" && \
      scl enable rh-maven35 "mvn -B -f kura/distrib/pom.xml clean install $MAVEN_PROPS -Pintel-up2-centos-7-nn -nsu" \
    ) && \
    ls -la /kura/kura/distrib/target && \
    yum -y history undo last && \
    yum -y install java-1.8.0-openjdk-headless && \
    yum -y install procps zip unzip gzip tar psmisc socat telnet dos2unix openssl net-tools hostname which && \
    yum -y clean all && rm -rf /var/cache/yum && \
    /kura/kura/distrib/target/kura_3.3.0-SNAPSHOT_intel-up2-centos-7-nn_installer.sh && \
    rm -Rf /kura /root/.m2 && \
    mkdir -p /opt/eclipse/kura/kura/packages && \
    cd /opt/eclipse/kura/kura/packages && \
    curl -O  https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.utils.fileinstall/0.5.1/de.dentrassi.kura.addons.utils.fileinstall-0.5.1.dp && \
    echo "de.dentrassi.kura.addons.utils.fileinstall=file\:/opt/eclipse/kura/kura/packages/de.dentrassi.kura.addons.utils.fileinstall-0.5.1.dp" > /opt/eclipse/kura/kura/dpa.properties && \
    echo "felix.fileinstall.disableNio2=true" >> /opt/eclipse/kura/kura/config.ini && \
    sed -ie "s/org.osgi.service.http.port=.*/org.osgi.service.http.port=8080/g" /opt/eclipse/kura/kura/config.ini && \
    mkdir /opt/eclipse/kura/load && \
    chmod a+rw -R /opt/eclipse && \
    find /opt/eclipse -type d | xargs chmod a+x && \
    chmod a+rwx /var/log && \
    `# Test for the existence of the entry point` \
    test -x /opt/eclipse/kura/bin/start_kura.sh

EXPOSE 8080

VOLUME ["/opt/eclipse/kura/load"]

ENTRYPOINT ["/opt/eclipse/kura/bin/start_kura.sh"]
