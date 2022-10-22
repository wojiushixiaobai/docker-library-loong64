FROM loongnix:20-slim as builder
WORKDIR /opt
ARG GUACD_VERSION=1.4.0
ENV LC_ALL=C.UTF-8

ARG PREFIX_DIR=/usr/local/guacamole

ARG BUILD_DIR=/tmp/guacd-docker-BUILD
ARG BUILD_DEPENDENCIES="          \
        autoconf                  \
        automake                  \
        gcc                       \
        libcairo2-dev             \
        libgcrypt-dev             \
        libjpeg62-turbo-dev       \
        libossp-uuid-dev          \
        libpango1.0-dev           \
        libpulse-dev              \
        libssh2-1-dev             \
        libssl-dev                \
        libtelnet-dev             \
        libtool                   \
        libvncserver-dev          \
        libwebsockets-dev         \
        libwebp-dev               \
        make"

ARG TOOLS="                       \
        ca-certificates           \
        curl                      \
        git                       \
        wget"

ARG DEBIAN_FRONTEND=noninteractive

RUN set -ex \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-get update \
    && apt-get install -y --no-install-recommends $BUILD_DEPENDENCIES \
    && apt-get install -y --no-install-recommends $TOOLS \
    && echo "no" | dpkg-reconfigure dash \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends freerdp2-dev \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && git clone -b ${GUACD_VERSION} https://github.com/apache/guacamole-server ${BUILD_DIR} \
    && mkdir -p ${PREFIX_DIR}/bin \
    && wget -O ${PREFIX_DIR}/bin/link-freerdp-plugins.sh https://github.com/apache/guacamole-server/raw/c880f02fe88f83ccabbbb5d057a64d4de3dc4219/src/guacd-docker/bin/link-freerdp-plugins.sh \
    && wget -O ${PREFIX_DIR}/bin/list-dependencies.sh https://github.com/apache/guacamole-server/raw/c880f02fe88f83ccabbbb5d057a64d4de3dc4219/src/guacd-docker/bin/list-dependencies.sh \
    && cp -f ${BUILD_DIR}/src/guacd-docker/bin/build-guacd.sh ${PREFIX_DIR}/bin \
    && chmod 755 ${PREFIX_DIR}/bin/*.sh

RUN ${PREFIX_DIR}/bin/build-guacd.sh "$BUILD_DIR" "$PREFIX_DIR"

RUN ${PREFIX_DIR}/bin/list-dependencies.sh     \
        ${PREFIX_DIR}/sbin/guacd               \
        ${PREFIX_DIR}/lib/libguac-client-*.so  \
        ${PREFIX_DIR}/lib/freerdp2/*guac*.so   \
        > ${PREFIX_DIR}/DEPENDENCIES

FROM loongnix:20-slim

ARG PREFIX_DIR=/usr/local/guacamole

ENV LANG="en_US.UTF-8"
ENV LD_LIBRARY_PATH=${PREFIX_DIR}/lib
ENV GUACD_LOG_LEVEL=info

ARG RUNTIME_DEPENDENCIES="            \
        netcat-openbsd                \
        ca-certificates               \
        ghostscript                   \
        fonts-liberation              \
        fonts-dejavu                  \
        freerdp2-dev                  \
        xfonts-terminus"

ARG DEBIAN_FRONTEND=noninteractive
COPY --from=builder ${PREFIX_DIR} ${PREFIX_DIR}

RUN set -ex \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-get update \
    && apt-get install -y --no-install-recommends $RUNTIME_DEPENDENCIES \
    && apt-get install -y --no-install-recommends $(cat "${PREFIX_DIR}"/DEPENDENCIES) \
    && echo "no" | dpkg-reconfigure dash \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/*

RUN ${PREFIX_DIR}/bin/link-freerdp-plugins.sh \
        ${PREFIX_DIR}/lib/freerdp2/libguac*.so

HEALTHCHECK --interval=5m --timeout=5s CMD nc -z 127.0.0.1 4822 || exit 1

ARG UID=1000
ARG GID=1000
RUN groupadd --gid $GID guacd
RUN useradd --system --create-home --shell /usr/sbin/nologin --uid $UID --gid $GID guacd

USER guacd

EXPOSE 4822

CMD /usr/local/guacamole/sbin/guacd -b 0.0.0.0 -L $GUACD_LOG_LEVEL -f
