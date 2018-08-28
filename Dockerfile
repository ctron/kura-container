FROM centos:7

MAINTAINER Jens Reimann <jreimann@redhat.com>
LABEL maintainer="Jens Reimann <jreimann@redhat.com>" \
      io.k8s.description="Containerized version of the Eclipse Kura™ IoT gateway" \
      io.openshift.non-scalable=true

ENV \
  DEFAULT_GIT_REPO=https://github.com/eclipse/kura.git \
  DEFAULT_GIT_BRANCH=develop \
  DEFAULT_KURA_COMMIT=8be442a1eb723667ca765acbfcd3982575b3e6ca \
  DEFAULT_PACKED=false \
  JAVA_HOME=/usr/lib/jvm/jre-1.8.0 \
  MAVEN_PROPS=-DskipTests \
  KURA_DIR=/opt/eclipse/kura \
  LAUNCHER_VERSION="1.4.0.v20161219-1356"

RUN \
    : ${GIT_REPO:=${DEFAULT_GIT_REPO}} && \
    : ${GIT_BRANCH:=${DEFAULT_GIT_BRANCH}} && \
    : ${KURA_COMMIT:=${DEFAULT_KURA_COMMIT}} && \
    : ${PACKED:=${DEFAULT_PACKED}} && \
    echo "$GIT_REPO / $GIT_BRANCH / $KURA_COMMIT" && \
    chmod a+x -R /usr/local/bin && \
    yum -y update && \
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
    \
    /kura/kura/distrib/target/kura_3.3.0-SNAPSHOT_intel-up2-centos-7-nn_installer.sh && \
    chmod a+rw -R /opt/eclipse && \
    find /opt/eclipse -type d | xargs chmod a+x && \
    chmod a+rwx /var/log && \
    `# Test for the existence of the entry point` \
    test -x "${KURA_DIR}/bin/start_kura.sh" && \
    rm -Rf /kura /root/.m2

COPY ./utils /usr/local/bin

RUN \
    dp-install "https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.utils.fileinstall/0.5.1/de.dentrassi.kura.addons.utils.fileinstall-0.5.1.dp" && \
    add-config-ini "felix.fileinstall.disableNio2=true" && \
    add-config-ini "felix.fileinstall.dir=/opt/eclipse/kura/load,/load" && \
    sed -ie "s/org.osgi.service.http.port=.*/org.osgi.service.http.port=8080/g" "${KURA_DIR}/kura/config.ini" && \
    install -m 0777 -D -d "${KURA_DIR}/load" && \
    pack-kura

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/kura-entry-point"]
