#CGO_ENABLED=0 ETCD_IP=127.0.0.1 PLUGIN=genie CNI_SPEC_VERSION=0.3.0
go test ./e2e/ -args --testKubeVersion=1.7 --testKubeConfig=/etc/kubernetes/admin.conf

