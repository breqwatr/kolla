# Kolla OpenStack Image Builder

This repository defines the automation used to build the Kolla-based OpenStack
container images.


## Manually executing the build
This automation is meant to be ran by a CD pipeline, but it can be ran "by hand" too.
It expects an Ubuntu server as a base OS.

Select a release:
```bash
export RELEASE="stable/stein"
```

Run the setup script:

```bash
bin/setup.sh
```

Run the build script:
```bash
bin/kolla-build.sh
```

