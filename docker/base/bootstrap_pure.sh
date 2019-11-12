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

Pre-build all guest distributions based on the root distribution
echo "Bootstrapping linux/386..."
GOOS=linux GOARCH=386 CGO_ENABLED=1 go install std

echo "Bootstrapping linux/arm64..."
GOOS=linux GOARCH=arm64 CGO_ENABLED=1 CC=aarch64-linux-gnu-gcc-6 go install std

TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64
echo "Bootstrapping android/armv7a..."
ARCH=armv7a
CC=$TOOLCHAIN/bin/$ARCH-linux-androideabi21-clang CXX=$TOOLCHAIN/bin/$ARCH-linux-androideabi21-clang++ GOOS=android GOARCH=arm CGO_ENABLED=1 go install std

echo "Bootstrapping android/arm64..."
ARCH=aarch64
CC=$TOOLCHAIN/bin/$ARCH-linux-android21-clang CXX=$TOOLCHAIN/bin/$ARCH-linux-android21-clang++ GOOS=android GOARCH=arm64 CGO_ENABLED=1 go install std

echo "Bootstrapping android/i686..."
ARCH=i686
CC=$TOOLCHAIN/bin/$ARCH-linux-android21-clang CXX=$TOOLCHAIN/bin/$ARCH-linux-android21-clang++ GOOS=android GOARCH=386 CGO_ENABLED=1 go install std

echo "Bootstrapping android/am64..."
ARCH=x86_64
CC=$TOOLCHAIN/bin/$ARCH-linux-android21-clang CXX=$TOOLCHAIN/bin/$ARCH-linux-android21-clang++ GOOS=android GOARCH=amd64 CGO_ENABLED=1 go install std

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

echo "Bootstrapping windows/amd64..."
GOOS=windows GOARCH=amd64 CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc go install std

echo "Bootstrapping windows/386..."
GOOS=windows GOARCH=386 CGO_ENABLED=1 CC=i686-w64-mingw32-gcc go install std

echo "Bootstrapping darwin/amd64..."
GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 CC=o64-clang go install std

echo "Bootstrapping darwin/386..."
GOOS=darwin GOARCH=386 CGO_ENABLED=1 CC=o32-clang go install std

# Install gomobile tool for android/ios frameworks
echo "Installing gomobile..."
go get -u golang.org/x/mobile/cmd/gomobile
cd /go/src/golang.org/x/mobile
# git checkout a27dd33d354d004b2de14a791df5af8a00f68b8e
go build ./cmd/gobind && mv ./gobind /usr/bin/ && go build ./cmd/gomobile && mv ./gomobile /usr/bin/

# /usr/bin/gomobile init -ndk /usr/local/android-ndk-r13b/
/usr/bin/gomobile version
