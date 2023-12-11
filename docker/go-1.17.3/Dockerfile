# Go cross compiler (xgo): Go 1.14
# Copyright (c) 2018 Péter Szilágyi. All rights reserved.
#
# Released under the MIT license.

FROM mysteriumnetwork/xgomobile:base

LABEL maintainer="team@mysterium.network"

ENV CGO_LDFLAGS_ALLOW -fobjc-arc
ENV GO_VERSION 1173

RUN \
  export ROOT_DIST=https://dl.google.com/go/go1.17.3.linux-amd64.tar.gz && \
  export ROOT_DIST_SHA=550f9845451c0c94be679faf116291e7807a8d78b43149f9506c1b15eb89008c && \
  \
$BOOTSTRAP_PURE

RUN git config --global --add safe.directory /source
