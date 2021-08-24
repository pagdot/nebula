FROM lsiobase/ubuntu:focal as downloader

ARG TARGETPLATFORM
ARG VERSION=1.3.0

#Install wget
RUN apt update && apt install -y wget

#Fetch and unpack
RUN case ${TARGETPLATFORM} in "linux/amd64") ARCH=amd64;; "linux/arm/v7") ARCH=arm-7;; "linux/arm64") ARCH=arm64;; esac && \
   wget https://github.com/slackhq/nebula/releases/download/v${VERSION}/nebula-linux-${ARCH}.tar.gz && \
   `tar -xzf nebula-linux-${ARCH}.tar.gz || true` # For some reason tar command exits with exit code 1 but it works fine

RUN /nebula -version

FROM lsiobase/ubuntu:focal

ARG VERSION=1.3.0

LABEL build_version="Pagdot version: ${VERSION}"
LABEL maintainer="pagdot"

COPY --from=downloader /nebula /usr/bin/nebula
COPY --from=downloader /nebula-cert /usr/bin/nebula-cert
COPY root/ /

VOLUME /config
