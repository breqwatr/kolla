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

To push to ECR you need to have the AWS CLI installed and set up. Once that's done:
```bash
bin/ecr-push.sh
```

# Environment Variables

The following environment variables apply:

```text
RELEASE			(required)		Defines the OpenStack release.
						Example: stein

IMAGE_REPO_NAME		(optional)		When empty, all images for the RELEASE are built.
						When defined, only that image is built.
						Example: cinder-volume

IMAGE_TAG		(optional)		When blank, "$RELEASE-$TIMESTAMP" is used as the image tag.
						When defined, each image is tagged as <image>:<IMAGE_TAG> 
						Example: stable-stein

AWS_ACCOUNT_ID		(required for ECR)	The numeric account ID used for tagging ECR images.

AWS_DEFAULT_REGION	(required for ECR)	The AWS region used for ECR.
```
