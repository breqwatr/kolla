# Kolla OpenStack Image Builder

This repository defines the automation used to build the Kolla-based OpenStack
container images.


## Manually executing the build
This automation is meant to be ran by a CD pipeline, but it can be ran "by hand" too.
It expects an Ubuntu server as a base OS.

Select a release:
```bash
export RELEASE="stein"
```

Run the setup script:

```bash
bin/setup.sh
```

Run the build script:
```bash
# Build all the images in the profile for the defined RELEASE
bin/kolla-build.sh

# Build a specific image
bin/kolla-build.sh cinder-volume


# Build an image for a registry and push it
bin/kolla-build.sh --registry <registry> cinder-volume
```

