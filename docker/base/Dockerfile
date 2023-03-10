# Go cross compiler (xgo): Base cross-compilation layer
# Copyright (c) 2023 Mysterium Network. All rights reserved.
#
# Released under the MIT license.

FROM openjdk:11-jdk-bullseye


#new
ENV HOME /home/gopher
ENV SHELL /bin/bash

# Mark the image as xgo enabled to support xgo-in-xgo
ENV XGO_IN_XGO 1

# Configure the Go environment, since it's not going to change
ENV PATH   /usr/local/go/bin:$PATH
ENV GOPATH /go

# Inject the remote file fetcher and checksum verifier
ADD fetch.sh /fetch.sh
ENV FETCH /fetch.sh
RUN chmod +x $FETCH

# install dependencies
RUN apt-get update \
  && apt-get install --no-install-recommends -y unzip openjdk-17-jdk \
  automake autogen build-essential ca-certificates                    \
  gcc-10-arm-linux-gnueabi g++-10-arm-linux-gnueabi libc6-dev-armel-cross                \
  gcc-10-arm-linux-gnueabihf g++-10-arm-linux-gnueabihf libc6-dev-armhf-cross            \
  gcc-10-aarch64-linux-gnu g++-10-aarch64-linux-gnu libc6-dev-arm64-cross                \
  gcc-10-mips-linux-gnu g++-10-mips-linux-gnu libc6-dev-mips-cross                       \
  gcc-10-mipsel-linux-gnu g++-10-mipsel-linux-gnu libc6-dev-mipsel-cross                 \
  gcc-10-mips64-linux-gnuabi64 g++-10-mips64-linux-gnuabi64 libc6-dev-mips64-cross       \
  gcc-10-mips64el-linux-gnuabi64 g++-10-mips64el-linux-gnuabi64 libc6-dev-mips64el-cross \
  gcc-10-multilib g++-10-multilib \
   gcc-mingw-w64 g++-mingw-w64 clang llvm-dev \
  libtool libxml2-dev uuid-dev libssl-dev swig pkg-config patch          \
  make xz-utils cpio wget zip unzip p7zip git mercurial bzr texinfo help2man cmake     \
  --no-install-recommends \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/*


# Fix any stock package issues
RUN ln -s /usr/include/asm-generic /usr/include/asm

# start user space task...
#USER ${USER}
RUN mkdir -p ${HOME}
WORKDIR ${HOME}

# ANDROID_VERSION=31 --> Android 12.
ENV SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip" \
    ANDROID_HOME="/usr/local/android-sdk" \
    ANDROID_VERSION=31 \
    ANDROID_BUILD_TOOLS_VERSION=31.0.0
ENV ANDROID_TOOLS_HOME=$ANDROID_HOME/cmdline-tools \
    ANDROID_SDK=$ANDROID_HOME

## Download Android SDK
# Extracted SDK path is modified by:
# https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiG1J2A3bD7AhXsl1YBHc8aArYQFnoECA0QAQ&url=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F65262340%2Fcmdline-tools-could-not-determine-sdk-root&usg=AOvVaw0Oqw-glr4hAU7DIQiYe66q
RUN mkdir -p "$ANDROID_TOOLS_HOME" .android \
    && touch .android/repositories.cfg \
    && cd "$ANDROID_HOME" \
    && $FETCH $SDK_URL 2ccbda4302db862a28ada25aa7425d99dce9462046003c1714b059b5c47970d8 \
    && unzip -d ${ANDROID_TOOLS_HOME} `basename $SDK_URL` \
    && mv ${ANDROID_TOOLS_HOME}/cmdline-tools ${ANDROID_TOOLS_HOME}/tools \
    && rm `basename $SDK_URL` \
    && yes | $ANDROID_TOOLS_HOME/tools/bin/sdkmanager --licenses \
    && cd -

## Install Android Build Tool and Libraries
RUN $ANDROID_TOOLS_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_TOOLS_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

# Install NDK
ENV NDK_VER="25.1.8937393"
RUN $ANDROID_TOOLS_HOME/tools/bin/sdkmanager "ndk;$NDK_VER"
# gomobile adapt new ndk path, so this is no longer needed.
# RUN ln -sf $ANDROID_HOME/ndk/$NDK_VER $ANDROID_HOME/ndk-bundle

# Inject the new Go root distribution downloader and bootstrapper
ADD bootstrap_pure.sh /bootstrap_pure.sh
ENV BOOTSTRAP_PURE /bootstrap_pure.sh
RUN chmod +x $BOOTSTRAP_PURE

# Inject the C dependency cross compiler
ADD build_deps.sh /build_deps.sh
ENV BUILD_DEPS /build_deps.sh
RUN chmod +x $BUILD_DEPS

# Inject the container entry point, the build script
ADD build.sh /build.sh
ENV BUILD /build.sh
RUN chmod +x $BUILD

ADD gomobile.sh /gomobile.sh
ENV GOMOBILE /gomobile.sh
RUN chmod +x $GOMOBILE

ENTRYPOINT ["/build.sh"]
