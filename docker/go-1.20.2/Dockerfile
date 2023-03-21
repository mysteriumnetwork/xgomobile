FROM mysteriumnetwork/xgomobile:base

#MAINTAINER Péter Szilágyi <peterke@gmail.com>

ENV CGO_LDFLAGS_ALLOW -fobjc-arc
ENV GO_VERSION 1196

ADD docker/base/bootstrap_pure.sh /bootstrap_pure.sh
ENV BOOTSTRAP_PURE /bootstrap_pure.sh
RUN chmod +x $BOOTSTRAP_PURE

ADD go.mod go.mod
ADD go.sum go.sum

RUN \
  export ROOT_DIST=https://go.dev/dl/go1.20.2.linux-amd64.tar.gz && \
  export ROOT_DIST_SHA=4eaea32f59cde4dc635fbc42161031d13e1c780b87097f4b4234cfce671f1768 && \
  \
$BOOTSTRAP_PURE
