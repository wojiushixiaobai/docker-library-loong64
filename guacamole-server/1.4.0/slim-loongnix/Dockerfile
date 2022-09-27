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
    && rm -rf /var/lib/apt/lists/*

ARG FreeRDP_DEB="                                                              \
        ./freerdp2-dev_2.3.0+dfsg1-2+deb11u1_loongarch64.deb                   \
        ./libfreerdp-client2-2_2.3.0+dfsg1-2+deb11u1_loongarch64.deb           \
        ./libfreerdp-server2-2_2.3.0+dfsg1-2+deb11u1_loongarch64.deb           \
        ./libfreerdp-shadow-subsystem2-2_2.3.0+dfsg1-2+deb11u1_loongarch64.deb \
        ./libfreerdp-shadow2-2_2.3.0+dfsg1-2+deb11u1_loongarch64.deb           \
        ./libfreerdp2-2_2.3.0+dfsg1-2+deb11u1_loongarch64.deb                  \
        ./libwinpr2-dev_2.3.0+dfsg1-2+deb11u1_loongarch64.deb                  \
        ./libwinpr2-2_2.3.0+dfsg1-2+deb11u1_loongarch64.deb                    \
        ./winpr-utils_2.3.0+dfsg1-2+deb11u1_loongarch64.deb                    \
        ./libwinpr-tools2-2_2.3.0+dfsg1-2+deb11u1_loongarch64.deb"

RUN set -ex \
    && cd /opt \
    && apt-get update \
    && wget https://download.jumpserver.org/files/freerdp-2.3.0.tar.gz \
    && tar -xf freerdp-2.3.0.tar.gz \
    && cd freerdp-2.3.0 \
    && apt-get install -y --no-install-recommends ${FreeRDP_DEB} \
    && rm -rf freerdp-2.3.0 freerdp-2.3.0.tar.gz \
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
        curl                          \
        ghostscript                   \
        fonts-liberation              \
        fonts-dejavu                  \
        wget                          \
        xfonts-terminus"

ARG DEBIAN_FRONTEND=noninteractive
COPY --from=builder ${PREFIX_DIR} ${PREFIX_DIR}

RUN set -ex \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-get update \
    && apt-get install -y $RUNTIME_DEPENDENCIES \
    && echo "no" | dpkg-reconfigure dash \
    && rm -rf /var/lib/apt/lists/*

ARG FreeRDP_DEB="                                                              \
        ./freerdp2-dev_2.3.0+dfsg1-2+deb11u1_loongarch64.deb                   \
        ./libfreerdp-client2-2_2.3.0+dfsg1-2+deb11u1_loongarch64.deb           \
        ./libfreerdp-server2-2_2.3.0+dfsg1-2+deb11u1_loongarch64.deb           \
        ./libfreerdp-shadow-subsystem2-2_2.3.0+dfsg1-2+deb11u1_loongarch64.deb \
        ./libfreerdp-shadow2-2_2.3.0+dfsg1-2+deb11u1_loongarch64.deb           \
        ./libfreerdp2-2_2.3.0+dfsg1-2+deb11u1_loongarch64.deb                  \
        ./libwinpr2-dev_2.3.0+dfsg1-2+deb11u1_loongarch64.deb                  \
        ./libwinpr2-2_2.3.0+dfsg1-2+deb11u1_loongarch64.deb                    \
        ./winpr-utils_2.3.0+dfsg1-2+deb11u1_loongarch64.deb                    \
        ./libwinpr-tools2-2_2.3.0+dfsg1-2+deb11u1_loongarch64.deb"

RUN set -ex \
    && cd /opt \
    && apt-get update \
    && wget https://download.jumpserver.org/files/freerdp-2.3.0.tar.gz \
    && tar -xf freerdp-2.3.0.tar.gz \
    && cd freerdp-2.3.0 \
    && apt-get install -y --no-install-recommends ${FreeRDP_DEB} \
    && apt-get install -y --no-install-recommends $(cat "${PREFIX_DIR}"/DEPENDENCIES) \
    && cd /opt \
    && rm -rf freerdp-2.3.0 freerdp-2.3.0.tar.gz \
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
