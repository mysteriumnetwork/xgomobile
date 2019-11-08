
NDK=/usr/local/android-ndk-r19c
HOST_TAG=linux-x86_64
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
ARCH=armv7a
export AR=$TOOLCHAIN/bin/$ARCH-linux-android-ar
export AS=$TOOLCHAIN/bin/$ARCH-linux-android-as
export CC=$TOOLCHAIN/bin/$ARCH-linux-android21-clang
export CXX=$TOOLCHAIN/bin/$ARCH-linux-android21-clang++
export LD=$TOOLCHAIN/bin/$ARCH-linux-android-ld
export RANLIB=$TOOLCHAIN/bin/$ARCH-linux-android-ranlib
export STRIP=$TOOLCHAIN/bin/$ARCH-linux-android-strip

GOOS=linux GOARCH=arm CGO_ENABLED=1 go install std

#ls /usr/local/android-ndk-r19c/toolchains/llvm/prebuilt/linux-x86_64/bin