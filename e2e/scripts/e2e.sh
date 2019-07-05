#!/bin/sh

#Install all plugins
bash -x ../../plugins_install.sh -all

sleep 10
cd ../..

make test-e2e testKubeVersion=1.7 testKubeConfig=/etc/kubernetes/admin.conf

sleep 20

bash -x ../../plugins_install.sh -deleteall
