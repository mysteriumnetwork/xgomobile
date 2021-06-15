# Go cross compiler (xgo): Go 1.14
# Copyright (c) 2018 Péter Szilágyi. All rights reserved.
#
# Released under the MIT license.

FROM mysteriumnetwork/xgomobile:base

MAINTAINER Péter Szilágyi <peterke@gmail.com>

ENV CGO_LDFLAGS_ALLOW -fobjc-arc
ENV GO_VERSION 1138

RUN \
  export ROOT_DIST=https://dl.google.com/go/go1.13.15.linux-amd64.tar.gz && \
  export ROOT_DIST_SHA=01cc3ddf6273900eba3e2bf311238828b7168b822bb57a9ccab4d7aa2acd6028 && \
  \
$BOOTSTRAP_PURE