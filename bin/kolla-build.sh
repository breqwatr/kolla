#!/bin/bash

if [[ ! -d kolla-env/ ]]; then
  echo "ERROR: You need to run bin/setup.sh first"
  exit 1
fi

# Let the pipeline define an image tag. If it's not defined, use a timestamp
if [[ "$IMAGE_TAG" == "" ]]; then
  IMAGE_TAG=$(date +%Y.%m.%d.%I.%M)
fi

source kolla-env/bin/activate

template='/etc/kolla/template-overrides.j2'
echo "kolla-build --template-override $template --tag $IMAGE_TAG $@"
kolla-build --template-override $template --tag $IMAGE_TAG $@
