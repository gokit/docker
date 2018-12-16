#!/usr/bin/env bash

set -eux;
env GOLANG_VERSION=$VERSION;

apt update && apt install -y \
	gcc \
	make bash wget curl ca-certificates\
	coreutils \
	openssl \
	golang build-essential

# set GOROOT_BOOTSTRAP such that we can actually build Go
# ... and set "cross-building" related vars to the installed system's values so that we create a build targeting the proper arch
# (for example, if our build host is GOARCH=amd64, but our build env/image is GOARCH=386, our build needs GOARCH=386)
export \
		GOROOT_BOOTSTRAP="$(go env GOROOT)" \
		GOOS="$(go env GOOS)" \
		GOARCH="$(go env GOARCH)" \
		GOHOSTOS="$(go env GOHOSTOS)" \
		GOHOSTARCH="$(go env GOHOSTARCH)"

# also explicitly set GO386 and GOARM if appropriate
# https://github.com/docker-library/golang/issues/184
apkArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')";
case "$apkArch" in \
	armhf) export GOARM='6' ;; \
	x86) export GO386='387' ;; \
esac;

wget -O go.tgz "https://golang.org/dl/go$VERSION.src.tar.gz";
tar -C /usr/local -xzf go.tgz;
rm go.tgz;

cd /usr/local/go/src;
./make.bash;

# https://github.com/golang/go/blob/0b30cf534a03618162d3015c8705dd2231e34703/src/cmd/dist/buildtool.go#L121-L125
# https://golang.org/cl/82095
# https://github.com/golang/build/blob/e3fe1605c30f6a3fd136b561569933312ede8782/cmd/release/releaselet.go#L56
rm -rf \
		/usr/local/go/pkg/bootstrap \
		/usr/local/go/pkg/obj \
		 /var/cache/apt/archives

export PATH="/usr/local/go/bin:$PATH"
go version
