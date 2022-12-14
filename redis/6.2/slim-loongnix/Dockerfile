FROM loongnix:20-slim

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r -g 999 redis && useradd -r -g redis -u 999 redis

# grab gosu for easy step-down from root
# https://github.com/tianon/gosu/releases
ENV GOSU_VERSION 1.14
RUN set -eux; \
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends ca-certificates dirmngr gnupg wget; \
	rm -rf /var/lib/apt/lists/*; \
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/wojiushixiaobai/gosu-loongarch64/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	chmod +x /usr/local/bin/gosu; \
	gosu --version; \
	gosu nobody true

ENV REDIS_VERSION 6.2.7
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-6.2.7.tar.gz
ENV REDIS_DOWNLOAD_SHA b7a79cc3b46d3c6eb52fa37dde34a4a60824079ebdfb3abfbbfa035947c55319

RUN set -eux; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		wget \
		\
		dpkg-dev \
		gcc \
		libc6-dev \
		libssl-dev \
		pkg-config \
		make \
	; \
	apt-get clean all; \
	rm -rf /var/lib/apt/lists/*; \
	\
	wget -O redis.tar.gz "$REDIS_DOWNLOAD_URL"; \
	echo "$REDIS_DOWNLOAD_SHA *redis.tar.gz" | sha256sum -c -; \
	mkdir -p /usr/src/redis; \
	tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1; \
	rm -f /usr/src/redis/deps/jemalloc/build-aux/config.guess /usr/src/redis/deps/jemalloc/build-aux/config.sub; \
	wget -O /usr/src/redis/deps/jemalloc/build-aux/config.sub "git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD"; \
	wget -O /usr/src/redis/deps/jemalloc/build-aux/config.guess "git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD"; \
	rm redis.tar.gz; \
	\
# disable Redis protected mode [1] as it is unnecessary in context of Docker
# (ports are not automatically exposed when running inside Docker, but rather explicitly by specifying -p / -P)
# [1]: https://github.com/redis/redis/commit/edd4d555df57dc84265fdfb4ef59a4678832f6da
	grep -E '^ *createBoolConfig[(]"protected-mode",.*, *1 *,.*[)],$' /usr/src/redis/src/config.c; \
	sed -ri 's!^( *createBoolConfig[(]"protected-mode",.*, *)1( *,.*[)],)$!\10\2!' /usr/src/redis/src/config.c; \
	grep -E '^ *createBoolConfig[(]"protected-mode",.*, *0 *,.*[)],$' /usr/src/redis/src/config.c; \
# for future reference, we modify this directly in the source instead of just supplying a default configuration flag because apparently "if you specify any argument to redis-server, [it assumes] you are going to specify everything"
# see also https://github.com/docker-library/redis/issues/4#issuecomment-50780840
# (more exactly, this makes sure the default behavior of "save on SIGTERM" stays functional by default)
	\
# https://github.com/jemalloc/jemalloc/issues/467 -- we need to patch the "./configure" for the bundled jemalloc to match how Debian compiles, for compatibility
# (also, we do cross-builds, so we need to embed the appropriate "--build=xxx" values to that "./configure" invocation)
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	extraJemallocConfigureFlags="--build=$gnuArch"; \
# https://salsa.debian.org/debian/jemalloc/-/blob/c0a88c37a551be7d12e4863435365c9a6a51525f/debian/rules#L8-23
	dpkgArch="$(dpkg --print-architecture)"; \
	case "${dpkgArch##*-}" in \
		amd64 | i386 | x32) extraJemallocConfigureFlags="$extraJemallocConfigureFlags --with-lg-page=12" ;; \
		*) extraJemallocConfigureFlags="$extraJemallocConfigureFlags --with-lg-page=16" ;; \
	esac; \
	extraJemallocConfigureFlags="$extraJemallocConfigureFlags --with-lg-hugepage=21"; \
	grep -F 'cd jemalloc && ./configure ' /usr/src/redis/deps/Makefile; \
	sed -ri 's!cd jemalloc && ./configure !&'"$extraJemallocConfigureFlags"' !' /usr/src/redis/deps/Makefile; \
	grep -F "cd jemalloc && ./configure $extraJemallocConfigureFlags " /usr/src/redis/deps/Makefile; \
	\
	export BUILD_TLS=yes; \
	make -C /usr/src/redis -j "$(nproc)" all; \
	make -C /usr/src/redis install; \
	\
# TODO https://github.com/redis/redis/pull/3494 (deduplicate "redis-server" copies)
	serverMd5="$(md5sum /usr/local/bin/redis-server | cut -d' ' -f1)"; export serverMd5; \
	find /usr/local/bin/redis* -maxdepth 0 \
		-type f -not -name redis-server \
		-exec sh -eux -c ' \
			md5="$(md5sum "$1" | cut -d" " -f1)"; \
			test "$md5" = "$serverMd5"; \
		' -- '{}' ';' \
		-exec ln -svfT 'redis-server' '{}' ';' \
	; \
	\
	rm -r /usr/src/redis; \
	\
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
	ldd /usr/local/bin/redis-server | awk '/=>/ { print $(NF-1) }' | while read LIBRARY; do LIBRARY_BASENAME=$(basename "$LIBRARY"); dpkg-query -S "*/$LIBRARY_BASENAME" || true; done | cut -f1 -d: | sort -u | xargs -r apt-mark manual; \
	apt-get autoremove -y \
		binutils \
		binutils-common \
		binutils-loongarch64-linux-gnu \
		bzip2 \
		cpp \
		cpp-8 \
		dirmngr \
		dpkg-dev \
		gnupg gnupg-l10n \
		gnupg-utils \
		gpg \
		gpg-agent \
		gpg-wks-client \
		gpg-wks-server \
		gpgconf \
		gpgsm \
		libassuan0 \
		libatomic1 \
		libbinutils \
		libcc1-0 \
		libdpkg-perl \
		libgdbm-compat4 \
		libgdbm6 \
		libgomp1 \
		libldap-2.4-2 \
		libldap-common \
		liblocale-gettext-perl \
		libmpc3 \
		libmpfr6 \
		libnpth0 \
		libperl5.28 \
		libreadline7 \
		libsasl2-2 \
		libsasl2-modules-db \
		libsqlite3-0 \
		libtext-charwidth-perl \
		libtext-iconv-perl \
		make \
		patch \
		perl \
		perl-modules-5.28 \
		pinentry-curses \
		readline-common \
		xz-utils \
	; \
	dpkg -l | grep "^rc" | awk '{print $2}' | xargs apt-get purge -y; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	apt-get clean all; \
	rm -rf /var/lib/apt/lists/*; \
	\
	redis-cli --version; \
	redis-server --version

RUN mkdir /data && chown redis:redis /data
VOLUME /data
WORKDIR /data

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 6379
CMD ["redis-server"]
