FROM debian:bullseye-slim AS builder
WORKDIR /opt
ARG GUACD_VERSION=1.5.5
ENV LC_ALL=C.UTF-8

ARG PREFIX_DIR=/opt/guacamole

ARG BUILD_DIR=/tmp/guacamole-server

ARG WITH_FREERDP='2(\.\d+)+'
ARG WITH_LIBSSH2='libssh2-\d+(\.\d+)+'
ARG WITH_LIBTELNET='\d+(\.\d+)+'
ARG WITH_LIBVNCCLIENT='LibVNCServer-\d+(\.\d+)+'
ARG WITH_LIBWEBSOCKETS='v\d+(\.\d+)+'

ARG FREERDP_OPTS="\
    -DBUILTIN_CHANNELS=OFF \
    -DCHANNEL_URBDRC=OFF \
    -DWITH_ALSA=OFF \
    -DWITH_CAIRO=ON \
    -DWITH_CHANNELS=ON \
    -DWITH_CLIENT=ON \
    -DWITH_CUPS=OFF \
    -DWITH_DIRECTFB=OFF \
    -DWITH_FFMPEG=OFF \
    -DWITH_GSM=OFF \
    -DWITH_GSSAPI=OFF \
    -DWITH_IPP=OFF \
    -DWITH_JPEG=ON \
    -DWITH_LIBSYSTEMD=OFF \
    -DWITH_MANPAGES=OFF \
    -DWITH_OPENH264=OFF \
    -DWITH_OPENSSL=ON \
    -DWITH_OSS=OFF \
    -DWITH_PCSC=OFF \
    -DWITH_PULSE=OFF \
    -DWITH_SERVER=OFF \
    -DWITH_SERVER_INTERFACE=OFF \
    -DWITH_SHADOW_MAC=OFF \
    -DWITH_SHADOW_X11=OFF \
    -DWITH_SSE2=OFF \
    -DWITH_WAYLAND=OFF \
    -DWITH_X11=OFF \
    -DWITH_X264=OFF \
    -DWITH_XCURSOR=ON \
    -DWITH_XEXT=ON \
    -DWITH_XI=OFF \
    -DWITH_XINERAMA=OFF \
    -DWITH_XKBFILE=ON \
    -DWITH_XRENDER=OFF \
    -DWITH_XTEST=OFF \
    -DWITH_XV=OFF \
    -DWITH_ZLIB=ON"

ARG GUACAMOLE_SERVER_OPTS="\
    --disable-guaclog"

ARG LIBSSH2_OPTS="\
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_SHARED_LIBS=ON"

ARG LIBTELNET_OPTS="\
    --disable-static \
    --disable-util"

ARG LIBVNCCLIENT_OPTS=""

ARG LIBWEBSOCKETS_OPTS="\
    -DDISABLE_WERROR=ON \
    -DLWS_WITHOUT_SERVER=ON \
    -DLWS_WITHOUT_TESTAPPS=ON \
    -DLWS_WITHOUT_TEST_CLIENT=ON \
    -DLWS_WITHOUT_TEST_PING=ON \
    -DLWS_WITHOUT_TEST_SERVER=ON \
    -DLWS_WITHOUT_TEST_SERVER_EXTPOLL=ON \
    -DLWS_WITH_STATIC=OFF"

ARG BUILD_DEPENDENCIES="          \
        autoconf                  \
        automake                  \
        build-essential           \
        cmake                     \
        gcc                       \
        git                       \
        g++                       \
        libcairo2-dev             \
        libjpeg62-turbo-dev       \
        libssl-dev                \
        libtool                   \
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
    && apt-get install -y --no-install-recommends gcc-multilib || true \
    && echo "no" | dpkg-reconfigure dash \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && git clone -b ${GUACD_VERSION} https://github.com/apache/guacamole-server ${BUILD_DIR} \
    && wget -O ${BUILD_DIR}/src/guacd-docker/bin/link-freerdp-plugins.sh https://github.com/apache/guacamole-server/raw/c880f02fe88f83ccabbbb5d057a64d4de3dc4219/src/guacd-docker/bin/link-freerdp-plugins.sh \
    && wget -O ${BUILD_DIR}/src/guacd-docker/bin/list-dependencies.sh https://github.com/apache/guacamole-server/raw/c880f02fe88f83ccabbbb5d057a64d4de3dc4219/src/guacd-docker/bin/list-dependencies.sh \
    && chmod 755 ${BUILD_DIR}/src/guacd-docker/bin/*.sh

RUN ${BUILD_DIR}/src/guacd-docker/bin/build-all.sh

RUN ${BUILD_DIR}/src/guacd-docker/bin/list-dependencies.sh \
        ${PREFIX_DIR}/sbin/guacd                           \
        ${PREFIX_DIR}/lib/libguac-client-*.so              \
        ${PREFIX_DIR}/lib/freerdp2/*guac*.so               \
        > ${PREFIX_DIR}/DEPENDENCIES

FROM debian:bullseye-slim

ARG PREFIX_DIR=/opt/guacamole

ENV LANG="en_US.UTF-8"
ENV LD_LIBRARY_PATH=${PREFIX_DIR}/lib
ENV GUACD_LOG_LEVEL=info

ARG RUNTIME_DEPENDENCIES="            \
        ca-certificates               \
        fonts-dejavu                  \
        fonts-liberation              \
        ghostscript                   \
        netcat-openbsd                \
        xfonts-terminus"

ARG DEBIAN_FRONTEND=noninteractive
COPY --from=builder ${PREFIX_DIR} ${PREFIX_DIR}

RUN set -ex \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-get update \
    && apt-get install -y --no-install-recommends $RUNTIME_DEPENDENCIES \
    && apt-get install -y --no-install-recommends $(cat "${PREFIX_DIR}"/DEPENDENCIES) \
    && echo "no" | dpkg-reconfigure dash \
    && rm -rf /var/lib/apt/lists/*

HEALTHCHECK --interval=5m --timeout=5s CMD nc -z 127.0.0.1 4822 || exit 1

ARG UID=1000
ARG GID=1000
RUN groupadd --gid $GID guacd
RUN useradd --system --create-home --shell /usr/sbin/nologin --uid $UID --gid $GID guacd

USER guacd

EXPOSE 4822

CMD /opt/guacamole/sbin/guacd -b 0.0.0.0 -L $GUACD_LOG_LEVEL -f
