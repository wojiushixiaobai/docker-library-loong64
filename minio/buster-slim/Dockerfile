FROM golang:1.19-buster AS builder-minio
ARG TARGETARCH
ARG MINIO_VERSION=RELEASE.2023-06-09T07-32-12Z

WORKDIR /opt
RUN set -ex \
    && git clone -b ${MINIO_VERSION} --depth=1 https://github.com/minio/minio.git

ARG GOPROXY=https://goproxy.cn,direct
WORKDIR /opt/minio
RUN set -ex \
    && sed -i 's@minisign@# minisign@g' dockerscripts/verify-minio.sh \
    && MINIO_RELEASE="RELEASE" make build \
    && cp minio minio.${MINIO_VERSION} \
    && echo $(sha256sum minio.${MINIO_VERSION}) > minio.sha256sum \
    && ./minio --version

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

LABEL name="MinIO" \
      vendor="MinIO Inc <dev@min.io>" \
      maintainer="MinIO Inc <dev@min.io>" \
      version="${RELEASE}" \
      release="${RELEASE}" \
      summary="MinIO is a High Performance Object Storage, API compatible with Amazon S3 cloud storage service." \
      description="MinIO object storage is fundamentally different. Designed for performance and the S3 API, it is 100% open-source. MinIO is ideal for large, private cloud environments with stringent security requirements and delivers mission-critical availability across a diverse range of workloads."

ENV MINIO_ACCESS_KEY_FILE=access_key \
    MINIO_SECRET_KEY_FILE=secret_key \
    MINIO_ROOT_USER_FILE=access_key \
    MINIO_ROOT_PASSWORD_FILE=secret_key \
    MINIO_KMS_SECRET_KEY_FILE=kms_master_key \
    MINIO_UPDATE_MINISIGN_PUBKEY="RWTx5Zr1tiHQLwG9keckT0c45M3AGeHD6IvimQHpyRywVWGbP1aVSGav" \
    MINIO_CONFIG_ENV_FILE=config.env \
    PATH=/opt/bin:$PATH

COPY --from=builder-minio /opt/minio/dockerscripts/verify-minio.sh /usr/bin/verify-minio.sh
COPY --from=builder-minio /opt/minio/dockerscripts/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
COPY --from=builder-minio /opt/minio/CREDITS /licenses/CREDITS
COPY --from=builder-minio /opt/minio/LICENSE /licenses/LICENSE
COPY --from=builder-minio /opt/minio/minio /opt/bin/minio
COPY --from=builder-minio /opt/minio/minio.sha256sum /opt/bin/minio.sha256sum
COPY --from=builder-mc /opt/mc/mc /opt/bin/mc

RUN set -ex \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates util-linux gzip lsof tar net-tools iproute2 iputils-ping jq \
    && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* \
    && chmod +x /usr/bin/verify-minio.sh \
    && chmod +x /usr/bin/docker-entrypoint.sh \
    && chmod +x /opt/bin/minio \
    && chmod +x /opt/bin/mc \
    && gzip /opt/bin/mc \
    && /usr/bin/verify-minio.sh

EXPOSE 9000

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

VOLUME ["/data"]

CMD ["minio"]