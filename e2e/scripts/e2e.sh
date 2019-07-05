#!/bin/sh

cd ../..
# Install all plugins
bash -x plugins_install.sh -all

sleep 10

# E2E tests
make test-e2e testKubeVersion=1.7 testKubeConfig=/etc/kubernetes/admin.conf

sleep 20
# delete all plugins
bash -x plugins_install.sh -deleteall
