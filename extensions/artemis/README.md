# Artemis Broker extension

This is an example how the Docker image can be extended with additional Kura packages.

In this example the [Artemis broker](https://activemq.apache.org/artemis/) addon is deployed as
a default component to the Kura emulator instance.

In addition the image is seeded with a new default configuration, containing a configuration for the broker
which enables AMQP and MQTT support.

**Note:** As Artemis comes as part of Kura now this example isn't no longer necessary
to provide support for a broker in Kura. However the example still is valid showing
how the emulator image can be extended with additional functionality.

## Connecting

By default this broker exports via MQTT and AMQP. MQTT is on port 1883, AMQP on port 5672.

The user for accessing the broker is `guest` with the password `test12`.

There is one topic named `TEST.T.1`.

You will need to start the image with an additional `-p 1883:1883` if you want MQTT
and `-p 5672:5672` if you want AMQP.
