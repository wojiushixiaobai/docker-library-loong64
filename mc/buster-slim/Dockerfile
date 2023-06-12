FROM golang:1.19-buster AS builder-mc
ARG TARGETARCH
ARG MC_VERSION=RELEASE.2023-06-06T13-48-56Z

WORKDIR /opt
RUN set -ex \
    && git clone -b ${MC_VERSION} --depth=1 https://github.com/minio/mc.git

ARG GOPROXY=https://goproxy.cn,direct
WORKDIR /opt/mc
RUN set -ex \
    && MC_RELEASE="RELEASE" make build \
    && ./mc --version

FROM debian:buster-slim

ARG TARGETARCH

ARG RELEASE

COPY --from=builder-mc /opt/mc/mc /usr/bin/mc
COPY --from=builder-mc /opt/mc/CREDITS /licenses/CREDITS
COPY --from=builder-mc /opt/mc/LICENSE /licenses/LICENSE

RUN set -ex \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates util-linux gzip lsof tar net-tools jq \
    && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* \
    && chmod +x /usr/bin/mc

ENTRYPOINT ["mc"]