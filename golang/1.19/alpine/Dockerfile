#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM alpine:3.11

RUN apk add --no-cache ca-certificates

# set up nsswitch.conf for Go's "netgo" implementation
# - https://github.com/golang/go/blob/go1.9.1/src/net/conf.go#L194-L275
# - docker run --rm debian grep '^hosts:' /etc/nsswitch.conf
RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

ENV PATH /usr/local/go/bin:$PATH

ENV GOLANG_VERSION 1.19.11

RUN set -eux; \
	apk add --no-cache --virtual .fetch-deps gnupg; \
	arch="$(apk --print-arch)"; \
	url=; \
	case "$arch" in \
		'x86_64') \
			export GOAMD64='v1' GOARCH='amd64' GOOS='linux'; \
			;; \
		'armhf') \
			export GOARCH='arm' GOARM='6' GOOS='linux'; \
			;; \
		'armv7') \
			export GOARCH='arm' GOARM='7' GOOS='linux'; \
			;; \
		'aarch64') \
			export GOARCH='arm64' GOOS='linux'; \
			;; \
		'x86') \
			export GO386='softfloat' GOARCH='386' GOOS='linux'; \
			;; \
		'ppc64le') \
			export GOARCH='ppc64le' GOOS='linux'; \
			;; \
		's390x') \
			export GOARCH='s390x' GOOS='linux'; \
			;; \
		'loongarch64') \
			export GOARCH='loong64' GOOS='linux'; \
			;; \
		*) echo >&2 "error: unsupported architecture '$arch' (likely packaging update needed)"; exit 1 ;; \
	esac; \
	build=; \
	if [ -z "$url" ]; then \
# https://github.com/golang/go/issues/38536#issuecomment-616897960
		build=1; \
		url='http://ftp.loongnix.cn/toolchain/golang/go-1.19/abi1.0/go1.19.11.src.tar.gz'; \
		sha256='70e2d2b353af36a7b02882d34e84b13fdd34629d084884c99f260d7c841a7407'; \
# the precompiled binaries published by Go upstream are not compatible with Alpine, so we always build from source here 😅
	fi; \
	\
	wget -O go.tgz "$url"; \
	echo "$sha256 *go.tgz" | sha256sum -c -; \
	\
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	\
	if [ -n "$build" ]; then \
		apk add --no-cache --virtual .build-deps \
			bash \
			gcc \
			go \
			musl-dev \
		; \
		\
		export GOCACHE='/tmp/gocache'; \
		\
		( \
			cd /usr/local/go/src; \
# set GOROOT_BOOTSTRAP + GOHOST* such that we can build Go successfully
			export GOROOT_BOOTSTRAP="$(go env GOROOT)" GOHOSTOS="$GOOS" GOHOSTARCH="$GOARCH"; \
			if [ "${GOARCH:-}" = '386' ]; then \
# https://github.com/golang/go/issues/52919; https://github.com/docker-library/golang/pull/426#issuecomment-1152623837
				export CGO_CFLAGS='-fno-stack-protector'; \
			fi; \
			./make.bash; \
		); \
		\
		apk del --no-network .build-deps; \
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
	apk del --no-network .fetch-deps; \
	\
	go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
