# Quick reference
- Maintained by:  
[the Docker Community](https://github.com/wojiushixiaobai/docker-library-loong64)

- Where to get help:  
[the Docker Community Slack](https://dockr.ly/comm-slack), [Server Fault](https://serverfault.com/help/on-topic), [Unix & Linux](https://unix.stackexchange.com/help/on-topic), or [Stack Overflow](https://stackoverflow.com/help/on-topic)

# Supported tags and respective Dockerfile links
(See ["What's the difference between 'Shared' and 'Simple' tags?" in the FAQ](https://github.com/docker-library/faq#whats-the-difference-between-shared-and-simple-tags).)

# Simple Tags
- [1.20-buster, 1.20](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/golang/1.20/buster/Dockerfile)
- [1.19-buster, 1.19](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/golang/1.19/buster/Dockerfile)
- [1.18-buster, 1.18](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/golang/1.18/buster/Dockerfile)

# Quick reference (cont.)
- Where to file issues:  
[https://github.com/wojiushixiaobai/docker-library-loong64/issues](https://github.com/wojiushixiaobai/docker-library-loong64/issues?q=)

- Supported architectures: ([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
amd64, arm64, loong64

Source of this description:
[docs repo's golang/ directory](https://github.com/docker-library/docs/tree/master/golang) ([history](https://github.com/docker-library/docs/commits/master/golang))

# What is Go?
Go (a.k.a., Golang) is a programming language first developed at Google. It is a statically-typed language with syntax loosely derived from C, but with additional features such as garbage collection, type safety, some dynamic-typing capabilities, additional built-in types (e.g., variable-length arrays and key-value maps), and a large standard library.

[wikipedia.org/wiki/Go_(programming_language)](http://en.wikipedia.org/wiki/Go_%28programming_language%29)

![logo](https://raw.githubusercontent.com/docker-library/docs/master/golang/logo.png)

# How to use this image
Note: `/go` is world-writable to allow flexibility in the user which runs the container (for example, in a container started with `--user 1000:1000`, running `go get github.com/example/...` into the default `$GOPATH` will succeed). While the `777` directory would be insecure on a regular host setup, there are not typically other processes or users inside the container, so this is equivalent to `700` for Docker usage, but allowing for `--user` flexibility.

## Start a Go instance in your app
The most straightforward way to use this image is to use a Go container as both the build and runtime environment. In your `Dockerfile`, writing something along the lines of the following will compile and run your project (assuming it uses `go.mod` for dependency management):
```
FROM jumpserver/golang:1.20

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN go build -v -o /usr/local/bin/app ./...

CMD ["app"]
```
You can then build and run the Docker image:
```
$ docker build -t my-golang-app .
$ docker run -it --rm --name my-running-app my-golang-app
```

## Compile your app inside the Docker container
There may be occasions where it is not appropriate to run your app inside a container. To compile, but not run your app inside the Docker instance, you can write something like:
```
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang:1.20 go build -v
```
This will add your current directory as a volume to the container, set the working directory to the volume, and run the command `go build` which will tell go to compile the project in the working directory and output the executable to `myapp`. Alternatively, if you have a `Makefile`, you can run the `make` command inside your container.
```
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang:1.20 make
```

## Cross-compile your app inside the Docker container
If you need to compile your application for a platform other than linux/amd64 (such as windows/386):
```
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp -e GOOS=windows -e GOARCH=386 jumpserver/golang:1.20 go build -v
```
Alternatively, you can build for multiple platforms at once:
```
$ docker run --rm -it -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang:1.20 bash
$ for GOOS in darwin linux; do
>   for GOARCH in 386 amd64; do
>     export GOOS GOARCH
>     go build -v -o myapp-$GOOS-$GOARCH
>   done
> done
```

# Image Variants
The `jumpserver/golang` images come in many flavors, each designed for a specific use case.

## jumpserver/golang:<version>
This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is designed to be used both as a throw away container (mount your source code and start the container to start your app), as well as the base to build other images off of.

Some of these tags may have names like bookworm or bullseye in them. These are the suite code names for releases of [Debian](https://wiki.debian.org/DebianReleases) and indicate which release the image is based on. If your image needs to install any additional packages beyond what comes with the image, you'll likely want to specify one of these explicitly to minimize breakage when there are new releases of Debian.

# License
View [license information](http://golang.org/LICENSE) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

Some additional license information which was able to be auto-detected might be found in [the repo-info repository's golang/ directory](https://github.com/docker-library/repo-info/tree/master/repos/golang).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.