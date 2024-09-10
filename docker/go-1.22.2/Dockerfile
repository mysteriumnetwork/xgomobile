FROM mysteriumnetwork/xgomobile:base

LABEL maintainer="team@mysterium.network"

ENV CGO_LDFLAGS_ALLOW -fobjc-arc
ENV GO_VERSION 1222

RUN \
  export ROOT_DIST=https://go.dev/dl/go1.22.2.linux-amd64.tar.gz && \
  export ROOT_DIST_SHA=5901c52b7a78002aeff14a21f93e0f064f74ce1360fce51c6ee68cd471216a17 && \
  \
$BOOTSTRAP_PURE

RUN git config --global --add safe.directory /source
