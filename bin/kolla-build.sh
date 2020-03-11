#!/bin/bash

if [[ ! -d kolla-env/ ]]; then
  echo "ERROR: You need to run bin/setup.sh first"
  exit 1
fi

source kolla-env/bin/activate
kolla-build
