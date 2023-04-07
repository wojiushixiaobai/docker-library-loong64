FROM debian:buster-slim

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends autoconf \
        automake \
        bzip2 \
        dpkg-dev \
        file \
        g++ \
        gcc \
        imagemagick \
        nodejs \
        npm \
        libbz2-dev \
        libc6-dev \
        libcurl4-openssl-dev \
        libdb-dev \
        libevent-dev \
        libffi-dev \
        libgdbm-dev \
        libglib2.0-dev \
        libgmp-dev \
        libjpeg-dev \
        libkrb5-dev \
        liblzma-dev \
        libmagickcore-dev \
        libmagickwand-dev \
        libmaxminddb-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libpng-dev \
        libpq-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libtool \
        libwebp-dev \
        libxml2-dev \
        libxslt-dev \
        libyaml-dev \
        make \
        patch \
        unzip \
        xz-utils \
        zlib1g-dev \
        \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && npm config set registry https://registry.npmmirror.com \
    && npm install -g yarn \
    && yarn config set registry https://registry.npmmirror.com \
    && npm cache verify

CMD [ "node" ]
