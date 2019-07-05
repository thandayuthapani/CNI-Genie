#!/bin/sh

#bash -x ../../plugins_install.sh -all

#sleep 10

make test-e2e testKubeVersion=1.7 testKubeConfig=/etc/kubernetes/admin.conf

sleep 20


