# !/usr/bin/bash
#
set -eux

rm -rf ~/.cache/agent
rm -rf data
cp -rf data-orig data

# Use installer built from installer repo, may need to update IMAGES environment variable in /usr/local/share/assisted-service/
INSTALLER_DIR=/home/rwsu/go/src/github.com/openshift/installer/bin
cp $INSTALLER_DIR/openshift-install ./data
export OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE=quay.io/openshift-release-dev/ocp-release:4.15.0-rc.2-x86_64

# Use installer downloaded from release
# RELEASE=quay.io/openshift-release-dev/ocp-release:4.15.0-ec.3-x86_64
# oc adm release extract --tools $RELEASE --to=./data
# cd data; tar xvzf openshift-install-linux*.tar.gz; cd ..

./data/openshift-install agent create cluster-manifests --dir ./data
./data/openshift-install agent create image --dir ./data
