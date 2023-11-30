FROM mysteriumnetwork/xgomobile:base

LABEL maintainer="team@mysterium.network"

ENV CGO_LDFLAGS_ALLOW -fobjc-arc
ENV GO_VERSION 1214

RUN \
  export ROOT_DIST=https://go.dev/dl/go1.21.4.linux-amd64.tar.gz && \
  export ROOT_DIST_SHA=73cac0215254d0c7d1241fa40837851f3b9a8a742d0b54714cbdfb3feaf8f0af && \
  \
$BOOTSTRAP_PURE
