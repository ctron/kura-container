FROM ctron/kura-container:develop

MAINTAINER Jens Reimann <jreimann@redhat.com>
LABEL maintainer "Jens Reimann <jreimann@redhat.com>"

RUN \
    unpack-kura && \
    echo "1" && \
    dp-install "https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.amqp/0.6.0/de.dentrassi.kura.addons.amqp-0.6.0.dp" && \
    echo "2" && \
    dp-install "https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.camel.groovy/0.6.0/de.dentrassi.kura.addons.camel.groovy-0.6.0.dp" && \
    echo "3" && \
    dp-install "https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.camel.gson/0.6.0/de.dentrassi.kura.addons.camel.gson-0.6.0.dp" && \
    echo "4" && \
    dp-install "https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.camel.http/0.6.0/de.dentrassi.kura.addons.camel.http-0.6.0.dp" && \
    echo "5" && \
    dp-install "https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.camel.iec60870/0.6.0/de.dentrassi.kura.addons.camel.iec60870-0.6.0.dp" && \
    echo "6" && \
    dp-install "https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.camel.jetty/0.6.0/de.dentrassi.kura.addons.camel.jetty-0.6.0.dp" && \
    echo "7" && \
    dp-install "https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.camel.swagger/0.6.0/de.dentrassi.kura.addons.camel.swagger-0.6.0.dp" && \
    echo "8" && \
    dp-install "https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.camel.weather/0.6.0/de.dentrassi.kura.addons.camel.weather-0.6.0.dp" && \
    echo "9" && \
    dp-install "https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.paho/0.6.0/de.dentrassi.kura.addons.paho-0.6.0.dp" && \
    pack-kura

EXPOSE 5672 1883
