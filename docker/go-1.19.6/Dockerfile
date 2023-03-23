FROM mysteriumnetwork/xgomobile:base

MAINTAINER Péter Szilágyi <peterke@gmail.com>

ENV CGO_LDFLAGS_ALLOW -fobjc-arc
ENV GO_VERSION 1196

RUN \
  export ROOT_DIST=https://go.dev/dl/go1.19.6.linux-amd64.tar.gz && \
  export ROOT_DIST_SHA=e3410c676ced327aec928303fef11385702a5562fd19d9a1750d5a2979763c3d && \
  \
$BOOTSTRAP_PURE
