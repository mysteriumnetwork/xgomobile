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
fi
export GOROOT_BOOTSTRAP=$GOROOT

# Pre-build all guest distributions based on the root distribution
echo "Bootstrapping linux/386..."
GOOS=linux GOARCH=386 CGO_ENABLED=1 go install std

echo "Bootstrapping linux/arm64..."
GOOS=linux GOARCH=arm64 CGO_ENABLED=1 CC=aarch64-linux-gnu-gcc-10 go install std

if [ $GO_VERSION -ge 170 ]; then
  echo "Bootstrapping linux/mips64..."
  GOOS=linux GOARCH=mips64 CGO_ENABLED=1 CC=mips64-linux-gnuabi64-gcc-10 go install std

  echo "Bootstrapping linux/mips64le..."
  GOOS=linux GOARCH=mips64le CGO_ENABLED=1 CC=mips64el-linux-gnuabi64-gcc-10 go install std
fi

if [ $GO_VERSION -ge 180 ]; then
  echo "Bootstrapping linux/mips..."
  GOOS=linux GOARCH=mips CGO_ENABLED=1 CC=mips-linux-gnu-gcc-10 go install std

  echo "Bootstrapping linux/mipsle..."
  GOOS=linux GOARCH=mipsle CGO_ENABLED=1 CC=mipsel-linux-gnu-gcc-10 go install std
fi

# Install gomobile tool for android/ios frameworks
echo "Installing gomobile..."
export PATH=$PATH:$(go env GOPATH)/bin
go install golang.org/x/mobile/cmd/gomobile@latest
go install golang.org/x/mobile/cmd/gobind@latest

gomobile version
