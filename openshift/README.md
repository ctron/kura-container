# Using with OpenShift

It is possible to run the Kura emulator instance in an OpenShift instance.

Assuming you already have set up OpenShift it is possible to deploy the Kura Emulator
inside of OpenShift using either method described in the following sections.

The template will create a new build and deployment configuration. This will trigger
OpenShift to download the base docker images, pull the source code of Kura from Git and
completely rebuild it. There is also a Kura instance configured to instantiate that image once
as soon as the build is complete. Every re-build will automatically trigger a re-deployment.

## Installing

All following steps will assume that you already have create a new project in OpenShift named `kura`
for this. You will also need a working internet connection on the machine running OpenShift
and on the machine you will be using.

### Web console

* Click on "Add to project"
* Switch to "Import YAML / JSON"
* Either
  * Copy and paste the content of `kura-emphermal.yml` or `kura-persistent.yml` into the text area
  * Use the "Browse…" button and load the `kura-emphermal.yml` or `kura-persistent.yml` file
* Press "Create"
* In the following confirmation dialog:
  * Keep the defaults
  * Press "Continue"

### Command line

Issue the following commands from your command line of choice. Please
not that need to have the
[OpenShift CLI installed](https://docs.openshift.org/latest/cli_reference/get_started_cli.html) installed
and you need to be logged in to your OpenShift cluster with `oc login`.

    oc new-app --file=kura-emphermal.yml

Or:

    oc new-app --file=kura-persistent.yml

## Ephermal vs Persistent

There are two templates for deploying Kura. Emphermal and persistent.

Ephermal will loose all changes once the pod running Kura is destroyed. Each new pod will start
with a fresh installation of Kura. This may good for testing Kura.

Using the persistent template, a new volume will be allocated and the Kura instance will be copied
over to this volume on the first start. Subsequent starts will keep the Kura instance and all its data directories.

The main difference between two approaches is, that a new build with the persistent template will
restart the Kura pod, including a fresh container image (updated Java, OS, …) but it will keep the
same Kura version. In order to update Kura, you have to use the Kura update mechanisms. On the other hand,
updating Kura using its update mechanism will modify the Kura installation as expected.

## Stateful sets

The Kura instance is run as a "stateful set". This allows to keep a stable network name, and auto-allocate volumes as needed.

## Loading bundles with ConfigMaps

The Kura docker container allows to map the directory `/opt/eclipse/kura/load` and drop in OSGi bundles, which
will automatically be picked up by Apache FileInstall.

The OpenShift deployment will leverage that and map a configmap to `/load` (which is also monitored by
the Kura instance). This allows one to update the configmap with a new JAR and the Kura instance will pick
up this OSGi bundle and correctly register it.

**Note:** For this to work ConfigMaps with binary support are required. This requires OpenShift 3.10, Kubernetes 1.10.