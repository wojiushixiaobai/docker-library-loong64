#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM buildpack-deps:buster-scm

# install cgo-related dependencies
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
	; \
	rm -rf /var/lib/apt/lists/*

ENV PATH /usr/local/go/bin:$PATH

ENV GOLANG_VERSION 1.18.10

RUN set -eux; \
	arch="$(dpkg --print-architecture)"; arch="${arch##*-}"; \
	url=; \
	case "$arch" in \
		'amd64') \
			url='https://dl.google.com/go/go1.18.10.linux-amd64.tar.gz'; \
			sha256='5e05400e4c79ef5394424c0eff5b9141cb782da25f64f79d54c98af0a37f8d49'; \
			;; \
		'armel') \
			export GOARCH='arm' GOARM='5' GOOS='linux'; \
			;; \
		'armhf') \
			url='https://dl.google.com/go/go1.18.10.linux-armv6l.tar.gz'; \
			sha256='e9f2f2361364c04a8f0d12228e4c5c2b870f4d1639ca92031c4013a95aa205be'; \
			;; \
		'arm64') \
			url='https://dl.google.com/go/go1.18.10.linux-arm64.tar.gz'; \
			sha256='160497c583d4c7cbc1661230e68b758d01f741cf4bece67e48edc4fdd40ed92d'; \
			;; \
		'i386') \
			url='https://dl.google.com/go/go1.18.10.linux-386.tar.gz'; \
			sha256='9249551992c9518ec8ce6690d32206f12ed9122e360407f7e7ab9a6adc627a9b'; \
			;; \
		'mips64el') \
			export GOARCH='mips64le' GOOS='linux'; \
			;; \
		'ppc64el') \
			url='https://dl.google.com/go/go1.18.10.linux-ppc64le.tar.gz'; \
			sha256='761014290febf0e10dfeba44ec551792dad32270a11debee8ed4f30c5f3c760d'; \
			;; \
		's390x') \
			url='https://dl.google.com/go/go1.18.10.linux-s390x.tar.gz'; \
			sha256='9755ab0460a04b535e513fac84db2e1ae6a197d66d3a097e14aed3b3114df85d'; \
			;; \
		'loongarch64') \
			url='http://ftp.loongnix.cn/toolchain/golang/go-1.18/go1.18.10.linux-loong64.tar.gz'; \
			sha256='f4a306270300ebcb477db20dfeb38cb4127c9f19c37e4f445849c6a728866186'; \
			;; \
		*) echo >&2 "error: unsupported architecture '$arch' (likely packaging update needed)"; exit 1 ;; \
	esac; \
	build=; \
	if [ -z "$url" ]; then \
# https://github.com/golang/go/issues/38536#issuecomment-616897960
		build=1; \
		url='https://dl.google.com/go/go1.18.10.src.tar.gz'; \
		sha256='9cedcca58845df0c9474ae00274c44a95c9dfaefb132fc59921c28c7c106f8e6'; \
		echo >&2; \
		echo >&2 "warning: current architecture ($arch) does not have a compatible Go binary release; will be building from source"; \
		echo >&2; \
	fi; \
	\
	wget -O go.tgz "$url" --progress=dot:giga; \
	echo "$sha256 *go.tgz" | sha256sum -c -; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	\
	if [ -n "$build" ]; then \
		savedAptMark="$(apt-mark showmanual)"; \
		apt-get update; \
		apt-get install -y --no-install-recommends golang-go; \
		\
		export GOCACHE='/tmp/gocache'; \
		\
		( \
			cd /usr/local/go/src; \
# set GOROOT_BOOTSTRAP + GOHOST* such that we can build Go successfully
			export GOROOT_BOOTSTRAP="$(go env GOROOT)" GOHOSTOS="$GOOS" GOHOSTARCH="$GOARCH"; \
			./make.bash; \
		); \
		\
		apt-mark auto '.*' > /dev/null; \
		apt-mark manual $savedAptMark > /dev/null; \
		apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
		rm -rf /var/lib/apt/lists/*; \
		\
# remove a few intermediate / bootstrapping files the official binary release tarballs do not contain
		rm -rf \
			/usr/local/go/pkg/*/cmd \
			/usr/local/go/pkg/bootstrap \
			/usr/local/go/pkg/obj \
			/usr/local/go/pkg/tool/*/api \
			/usr/local/go/pkg/tool/*/go_bootstrap \
			/usr/local/go/src/cmd/dist/dist \
			"$GOCACHE" \
		; \
	fi; \
	\
	go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH