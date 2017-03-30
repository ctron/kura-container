# Using with OpenShift

It is possible to run the Kura emulator instance in an OpenShift instance.

Assuming you already have set up OpenShift it is possible to deploy the Kura Emulator
inside of OpenShift using either method described in the following sections.

All following tutorials assume that you have create a new project in OpenShift named `kura`
for this. You will also need a working internet connection on the machine running OpenShift
and on the machine you will be using.

The template will create a new build and deployment configuration. This will trigger
OpenShift to download the base docker images, pull the source code of Kura from Git and
completely rebuild it. Once this is ready it will 

## Manually

* Click on "Add to project"
* Switch to "Import YAML / JSON"
* Either
  * Copy and paste the content of `kura-template.yml` into the text area
  * Use the "Browse…" button and load the `kura-template.yml` file
* Press "Create"
* In the following confirmation dialog:
  * Keep the defaults
  * Press "OK"
