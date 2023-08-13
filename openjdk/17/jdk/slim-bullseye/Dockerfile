FROM debian:bullseye-slim

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata curl ca-certificates fontconfig locales \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

ENV JAVA_VERSION jdk-17.0.7+7_openj9-0.38.0

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
       aarch64|arm64) \
         ESUM='f1669d85687be17744ba835107504227caf03c00c88dba7461fda11a8c442734'; \
         BINARY_URL='https://github.com/ibmruntimes/semeru17-binaries/releases/download/jdk-17.0.7%2B7_openj9-0.38.0/ibm-semeru-open-jdk_aarch64_linux_17.0.7_7_openj9-0.38.0.tar.gz'; \
         ;; \
       amd64|x86_64) \
         ESUM='b46177ab82a2506cb858894fafbbbb922bbeefa4be441796e0ef5a8029599dca'; \
         BINARY_URL='https://github.com/ibmruntimes/semeru17-binaries/releases/download/jdk-17.0.7%2B7_openj9-0.38.0/ibm-semeru-open-jdk_x64_linux_17.0.7_7_openj9-0.38.0.tar.gz'; \
         ;; \
       ppc64el|ppc64le) \
         ESUM='5759bea739befea5730d5aedc51ebe4a2bd808914d0a6ceb7a1895d36f1b2066'; \
         BINARY_URL='https://github.com/ibmruntimes/semeru17-binaries/releases/download/jdk-17.0.7%2B7_openj9-0.38.0/ibm-semeru-open-jdk_ppc64le_linux_17.0.7_7_openj9-0.38.0.tar.gz'; \
         ;; \
       s390x) \
         ESUM='a21823c8c400ba1535b2aace96b0de3ee36e0811d566ccf6cb06b15e9efe4906'; \
         BINARY_URL='https://github.com/ibmruntimes/semeru17-binaries/releases/download/jdk-17.0.7%2B7_openj9-0.38.0/ibm-semeru-open-jdk_s390x_linux_17.0.7_7_openj9-0.38.0.tar.gz'; \
         ;;\
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p "$JAVA_HOME"; \
    cd "$JAVA_HOME"; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -f /tmp/openjdk.tar.gz; \
    javac --version; \
    java --version

CMD ["jshell"]