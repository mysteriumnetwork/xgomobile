#!/bin/bash
#
# Contains the Go tool-chain pure-Go bootstrapper, that as of Go 1.5, initiates
# not only a few pre-built Go cross compilers, but rather bootstraps all of the
# supported platforms from the origin Linux amd64 distribution.
#
# Usage: bootstrap_pure.sh
#
# Environment variables for remote bootstrapping:
#   FETCH         - Remote file fetcher and checksum verifier (injected by image)
#   ROOT_DIST     - 64 bit Linux Go binary distribution package
#   ROOT_DIST_SHA - 64 bit Linux Go distribution package checksum
#
# Environment variables for local bootstrapping:
#   GOROOT - Path to the lready installed Go runtime
set -e

# Download, verify and install the root distribution if pulled remotely
if [ "$GOROOT" == "" ]; then
  $FETCH $ROOT_DIST $ROOT_DIST_SHA

  tar -C /usr/local -xzf `basename $ROOT_DIST`
  rm -f `basename $ROOT_DIST`

  export GOROOT=/usr/local/go

  cat /patches/goruntime-*.diff | patch -p1 -f -N -r- -d "$GOROOT"
fi
export GOROOT_BOOTSTRAP=$GOROOT

# Pre-build all guest distributions based on the root distribution
echo "Bootstrapping linux/386..."
GOOS=linux GOARCH=386 CGO_ENABLED=1 go install std

echo "Bootstrapping linux/arm64..."
GOOS=linux GOARCH=arm64 CGO_ENABLED=1 CC=aarch64-linux-gnu-gcc-6 go install std

if [ $GO_VERSION -ge 170 ]; then
  echo "Bootstrapping linux/mips64..."
  GOOS=linux GOARCH=mips64 CGO_ENABLED=1 CC=mips64-linux-gnuabi64-gcc-6 go install std

  echo "Bootstrapping linux/mips64le..."
  GOOS=linux GOARCH=mips64le CGO_ENABLED=1 CC=mips64el-linux-gnuabi64-gcc-6 go install std
fi

if [ $GO_VERSION -ge 180 ]; then
  echo "Bootstrapping linux/mips..."
  GOOS=linux GOARCH=mips CGO_ENABLED=1 CC=mips-linux-gnu-gcc-6 go install std

  echo "Bootstrapping linux/mipsle..."
  GOOS=linux GOARCH=mipsle CGO_ENABLED=1 CC=mipsel-linux-gnu-gcc-6 go install std
fi

# Install gomobile tool for android/ios frameworks
echo "Installing gomobile..."
go get -u golang.org/x/mobile/cmd/gomobile
cd /go/src/golang.org/x/mobile
git checkout 3c8601c510d0503ac84d1e5cb8e24de550201dea
go build ./cmd/gobind && mv ./gobind /usr/bin/
go build ./cmd/gomobile && mv ./gomobile /usr/bin/

# use prebuilt toolchains
# /usr/bin/gomobile init -ndk /usr/local/android-ndk-r13b/
/usr/bin/gomobile version
