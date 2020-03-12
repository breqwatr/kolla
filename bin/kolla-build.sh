#!/bin/bash

if [[ ! -d kolla-env/ ]]; then
  echo "ERROR: You need to run bin/setup.sh first"
  exit 1
fi
source kolla-env/bin/activate
echo "kolla-build --template-override /etc/kolla/template-overrides.j2 $@"
kolla-build --template-override /etc/kolla/template-overrides.j2 $@
