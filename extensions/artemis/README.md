# Artemis Broker extension

This is an example how the Docker image can be extended with additional Kura packages.

In this example the [Artemis broker](https://activemq.apache.org/artemis/) addon is deployed as
a default component to the Kura emulator instance.

In addition the image is seeded with a new default configuration, containing a configuration for the broker
which enables AMQP and MQTT support.
 