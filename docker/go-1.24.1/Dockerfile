FROM mysteriumnetwork/xgomobile:base

LABEL maintainer="team@mysterium.network"

ENV CGO_LDFLAGS_ALLOW="-fobjc-arc"
ENV GO_VERSION=1222

RUN \
  export ROOT_DIST=https://go.dev/dl/go1.24.1.linux-amd64.tar.gz && \
  export ROOT_DIST_SHA=cb2396bae64183cdccf81a9a6df0aea3bce9511fc21469fb89a0c00470088073 && \
  \
$BOOTSTRAP_PURE && \
    rm -rf /home/gopher/.cache

RUN git config --global --add safe.directory /source
