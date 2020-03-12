#!/bin/bash

if [[ ! -d bin/ ]]; then
  echo "ERROR: Run this in the project root"
  exit 1
fi

if [[ "$(whoami)" != "root" ]]; then
  echo "ERROR: Must run this as root"
  exit 1
fi

# Confirm the release is supported
if [[ "$RELEASE" == "" ]]; then
  echo "ERROR: Environment variable '\$RELEASE' must be set. Example: 'stein'"
  echo "       Check the branch list in Kolla's github for valid options"
  exit 1
fi

apt-get update 1>/dev/null

# Install Docker
if [[ "$(which docker)" == "" ]]; then
  echo "Docker not found, installing now"
  apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable"
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io
fi

if [[ "$(which git)" == "" ]]; then
  apt-get install -y git
fi

# Install Kolla dependencies
deactivate 2>/dev/null
rm -rf kolla-env/
if [[ "$RELEASE" == "rocky" || "$RELEASE" == "stein" ]]; then
  # These expect python2
  apt-get install -y \
    python \
    python-dev \
    python-setuptools \
    python-virtualenv
  virtualenv kolla-env
else
  # everything newer expects python3
  apt-get install -y \
    python3 \
    python3-setuptools \
    python3-virtualenv
  python3 -m venv kolla-env
fi
source kolla-env/bin/activate


# Clone kolla from their GitHub
rm -rf kolla/
git clone --single-branch --branch "stable/$RELEASE" https://github.com/openstack/kolla.git

# Install tox for Kolla and the deps for this project's python code
pip install -U pip
pip install tox
pip install kolla/.

# Generate the Kolla config
pushd kolla
tox -e genconfig
popd

# Apply the config for this release
bin/apply-config.py
mkdir -p /etc/kolla
cp kolla/etc/kolla/kolla-build.conf /etc/kolla/

# Apply the image template overrides
cp conf/template-overrides.j2 /etc/kolla


