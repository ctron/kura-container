# Using with OpenShift

It is possible to run the Kura emulator instance in an OpenShift instance.

Assuming you already have set up OpenShift it is possible to deploy the Kura Emulator
inside of OpenShift using either method described in the following sections.

The template will create a new build and deployment configuration. This will trigger
OpenShift to download the base docker images, pull the source code of Kura from Git and
completely rebuild it. There is also a Kura instance configured to instantiate that image once
as soon as the build is complete. Every re-build will automatically trigger a re-deployment.

**Note**: There is currently no persistent configuration for this image configured.
So all you data will be lost when you re-start your pods.

## Installing

All following steps will assume that you already have create a new project in OpenShift named `kura`
for this. You will also need a working internet connection on the machine running OpenShift
and on the machine you will be using.

### Web console

* Click on "Add to project"
* Switch to "Import YAML / JSON"
* Either
  * Copy and paste the content of `kura-template.yml` into the text area
  * Use the "Browse…" button and load the `kura-template.yml` file
* Press "Create"
* In the following confirmation dialog:
  * Keep the defaults
  * Press "Continue"

### Command line

Issue the following commands from your command line of choice. Please
not that need to have the
[OpenShift CLI installed](https://docs.openshift.org/latest/cli_reference/get_started_cli.html) installed
and you need to be logged in to your OpenShift cluster with `oc login`.

    oc new-app --file=kura-template.yml
