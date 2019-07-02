# Disable make's implicit rules, which are not useful for golang, and slow down the build
# considerably.
.SUFFIXES:


GO_PATH=$(GOPATH)
SRCFILES=cni-genie.go
TEST_SRCFILES=$(wildcard *_test.go)

# Ensure that the dist directory is always created
MAKE_SURE_DIST_EXIST := $(shell mkdir -p dist)

.PHONY: clean plugin policy-controller policy-controller-binary admission-controller admission-controller-binary test-e2e
default: plugin policy-controller-binary admission-controller-binary

plugin: clean dist/genie


clean:
	rm -rf dist

policy-controller: genie-policy
policy-controller-binary: genie-policy-binary
admission-controller: nw-admission-controller
admission-controller-binary: nw-admission-controller-binary

release: clean

# Build the genie cni plugin
dist/genie: $(SRCFILES)
	echo "Building genie plugin..."
	@GOPATH=$(GO_PATH) CGO_ENABLED=0 go build -v -i -o dist/genie \
	-ldflags "-X main.VERSION=1.0 -s -w" cni-genie.go

nw-admission-controller-binary:
	cd controllers/network-admission-controller && make

nw-admission-controller:
	echo "Building genie network admission controller..."
	cd controllers/network-admission-controller && make admission-controller

genie-policy-binary:
	cd controllers/network-policy-controller && make

genie-policy:
	echo "Building genie network policy controller..."
	cd controllers/network-policy-controller && make policy-controller

.PHONY: e2e
e2e:
	./e2e/scripts/e2e.sh

.PHONY: test

ifeq ($(WHAT),)
    TESTDIR=.
else
    TESTDIR=${WHAT}
endif

ifeq ($(print),y)
    PRINT=-v
endif

test:
	go test ${PRINT} `go list ./${TESTDIR}/... | grep -v vendor | grep -v e2e | grep -v controllers`

