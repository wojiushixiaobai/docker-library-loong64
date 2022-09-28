FROM loongnix:20-slim

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && npm config set registry https://registry.npmmirror.com \
    && npm install -g yarn \
    && yarn config set registry https://registry.npmmirror.com \
    && npm cache verify

CMD [ "node" ]
