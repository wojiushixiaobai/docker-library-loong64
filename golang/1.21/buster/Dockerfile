#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "apply-templates.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM buildpack-deps:buster-scm  AS build

ENV PATH /usr/local/go/bin:$PATH

ENV GOLANG_VERSION 1.21.11

RUN set -eux; \
	now="$(date '+%s')"; \
	arch="$(dpkg --print-architecture)"; arch="${arch##*-}"; \
	url=; \
	case "$arch" in \
		'amd64') \
			url='https://dl.google.com/go/go1.21.11.linux-amd64.tar.gz'; \
			sha256='54a87a9325155b98c85bc04dc50298ddd682489eb47f486f2e6cb0707554abf0'; \
			;; \
		'armhf') \
			url='https://dl.google.com/go/go1.21.11.linux-armv6l.tar.gz'; \
			sha256='a62bff8297816a387a36bbda2889dd0dbcf0f8ce03bc62162ecd6918d6acecb5'; \
			;; \
		'arm64') \
			url='https://dl.google.com/go/go1.21.11.linux-arm64.tar.gz'; \
			sha256='715d9a7ff72e4e0e3378c48318c52c6e4dd32a47c4136f3c08846f89b2ee2241'; \
			;; \
		'i386') \
			url='https://dl.google.com/go/go1.21.11.linux-386.tar.gz'; \
			sha256='8b00cbc2519c2d052177bf2c8472bf06578d3b0182eeb3406a1d7d4e5d4c59ef'; \
			;; \
		'mips64el') \
			url='https://dl.google.com/go/go1.21.11.linux-mips64le.tar.gz'; \
			sha256='d10166bb6ea6538e24f01ac9bcbbbaee5657d07b9edc11a82cbf569355a36534'; \
			;; \
		'ppc64el') \
			url='https://dl.google.com/go/go1.21.11.linux-ppc64le.tar.gz'; \
			sha256='6f5e18187abc4ff1c3173afbe38ef29f84b6d1ee7173f40075a4134863b209a5'; \
			;; \
		'riscv64') \
			url='https://dl.google.com/go/go1.21.11.linux-riscv64.tar.gz'; \
			sha256='3ee5f9aac2f252838d88bb4cf93560c567814889c74d87ad8a04be16aa5e1b21'; \
			;; \
		's390x') \
			url='https://dl.google.com/go/go1.21.11.linux-s390x.tar.gz'; \
			sha256='489c363d5da2d3d5709419bda61856582c5ebdc7874ca7ecdebf67d736d329e6'; \
			;; \
		'loongarch64') \
			url='http://ftp.loongnix.cn/toolchain/golang/go-1.21/abi1.0/go1.21.11.linux-loong64.tar.gz'; \
			sha256='b9319df453c355cad74dc378e23613105d53a5da7f92ba338ff221e0fbb10fcf'; \
			;; \
		*) echo >&2 "error: unsupported architecture '$arch' (likely packaging update needed)"; exit 1 ;; \
	esac; \
	\
	wget -O go.tgz "$url" --progress=dot:giga; \
	echo "$sha256 *go.tgz" | sha256sum -c -; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	\
# save the timestamp from the tarball so we can restore it for reproducibility, if necessary (see below)
	SOURCE_DATE_EPOCH="$(stat -c '%Y' /usr/local/go)"; \
	export SOURCE_DATE_EPOCH; \
	touchy="$(date -d "@$SOURCE_DATE_EPOCH" '+%Y%m%d%H%M.%S')"; \
# for logging validation/edification
	date --date "@$SOURCE_DATE_EPOCH" --rfc-2822; \
# sanity check (detected value should be older than our wall clock)
	[ "$SOURCE_DATE_EPOCH" -lt "$now" ]; \
	\
	if [ "$arch" = 'armhf' ]; then \
		[ -s /usr/local/go/go.env ]; \
		before="$(go env GOARM)"; [ "$before" != '7' ]; \
		{ \
			echo; \
			echo '# https://github.com/docker-library/golang/issues/494'; \
			echo 'GOARM=7'; \
		} >> /usr/local/go/go.env; \
		after="$(go env GOARM)"; [ "$after" = '7' ]; \
# (re-)clamp timestamp for reproducibility (allows "COPY --link" to be more clever/useful)
		touch -t "$touchy" /usr/local/go/go.env /usr/local/go; \
	fi; \
	\
# ideally at this point, we would just "COPY --link ... /usr/local/go/ /usr/local/go/" but BuildKit insists on creating the parent directories (perhaps related to https://github.com/opencontainers/image-spec/pull/970), and does so with unreproducible timestamps, so we instead create a whole new "directory tree" that we can "COPY --link" to accomplish what we want
	mkdir /target /target/usr /target/usr/local; \
	mv -vT /usr/local/go /target/usr/local/go; \
	ln -svfT /target/usr/local/go /usr/local/go; \
	touch -t "$touchy" /target/usr/local /target/usr /target; \
	\
# smoke test
	go version; \
# make sure our reproducibile timestamp is probably still correct (best-effort inline reproducibility test)
	epoch="$(stat -c '%Y' /target/usr/local/go)"; \
	[ "$SOURCE_DATE_EPOCH" = "$epoch" ]; \
	find /target -newer /target/usr/local/go -exec sh -c 'ls -ld "$@" && exit "$#"' -- '{}' +

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

ENV GOLANG_VERSION 1.21.11

# don't auto-upgrade the gotoolchain
# https://github.com/docker-library/golang/issues/472
ENV GOTOOLCHAIN=local

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
# (see notes above about "COPY --link")
COPY --from=build --link /target/ /
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH