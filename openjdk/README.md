# Quick reference
- Maintained by:  
[the Docker Community](https://github.com/wojiushixiaobai/docker-library-loong64)

## Simple Tags
- [17-slim-buster](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/openjdk/17/jdk/slim-buster/Dockerfile)
- [11-slim-buster](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/openjdk/11/jdk/slim-buster/Dockerfile)
- [8-slim-buster](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/openjdk/8/jdk/slim-buster/Dockerfile)

# Quick reference (cont.)
- Where to file issues:  
[https://github.com/wojiushixiaobai/docker-library-loong64/issues](https://github.com/wojiushixiaobai/docker-library-loong64/issues?q=)

- Supported architectures: ([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
amd64, arm64, loong64

- Source of this description:  
[docs repo's openjdk/ directory](https://github.com/docker-library/docs/tree/master/openjdk) ([history](https://github.com/docker-library/docs/commits/master/openjdk))

# What is OpenJDK?
OpenJDK (Open Java Development Kit) is a free and open source implementation of the Java Platform, Standard Edition (Java SE). OpenJDK is the official reference implementation of Java SE since version 7.

[wikipedia.org/wiki/OpenJDK](http://en.wikipedia.org/wiki/OpenJDK)

Java is a registered trademark of Oracle and/or its affiliates.

![logo](https://raw.githubusercontent.com/docker-library/docs/a3439b66b7980d1811f6b3835a3c541747172970/openjdk/logo.png)

# How to use this image
## Start a Java instance in your app
The most straightforward way to use this image is to use a Java container as both the build and runtime environment. In your `Dockerfile`, writing something along the lines of the following will compile and run your project:

```
FROM jumpserver/openjdk:11-slim-buster
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac Main.java
CMD ["java", "Main"]
```
You can then run and build the Docker image:

```
$ docker build -t my-java-app .
$ docker run -it --rm --name my-running-app my-java-app
```
## Compile your app inside the Docker container
There may be occasions where it is not appropriate to run your app inside a container. To compile, but not run your app inside the Docker instance, you can write something like:

```
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp openjdk:11-slim-buster javac Main.java
```
This will add your current directory as a volume to the container, set the working directory to the volume, and run the command `javac Main.java` which will tell Java to compile the code in `Main.java` and output the Java class file to `Main.class`.

## Make JVM respect CPU and RAM limits
On startup the JVM tries to detect the number of available CPU cores and RAM to adjust its internal parameters (like the number of garbage collector threads to spawn) accordingly. When the container is ran with limited CPU/RAM then the standard system API used by the JVM for probing it will return host-wide values. This can cause excessive CPU usage and memory allocation errors with older versions of the JVM.

Inside Linux containers, OpenJDK versions 8 and later can correctly detect the container-limited number of CPU cores and available RAM. For all currently supported OpenJDK versions this is turned on by default.

Inside Windows Server (non-Hyper-V) containers, the limit for the number of available CPU cores doesn't work (it's ignored by Host Compute Service). To set the limit manually the JVM can be started as:
```
$ start /b /wait /affinity 0x3 path/to/java.exe ...
```
In this example CPU affinity hex mask `0x3` will limit the JVM to 2 CPU cores.

RAM limit is supported by Windows Server containers, but currently the JVM cannot detect it. To prevent excessive memory allocations, `-XX:MaxRAM=...` option must be specified with the value that is not bigger than the containers RAM limit.

## Environment variables with periods in their names
Some shells (notably, [the BusyBox /bin/sh included in Alpine Linux](https://github.com/docker-library/openjdk/issues/135)) do not support environment variables with periods in the names (which are technically not POSIX compliant), and thus strip them instead of passing them through (as Bash does). If your application requires environment variables of this form, either use `CMD ["java", ...]` directly (no shell), or (install and) use Bash explicitly instead of `/bin/sh`.

# Image Variants
The `jumpserver/openjdk` images come in many flavors, each designed for a specific use case.

## jumpserver/openjdk:<version>
This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is designed to be used both as a throw away container (mount your source code and start the container to start your app), as well as the base to build other images off of.

Some of these tags may have names like bookworm or bullseye in them. These are the suite code names for releases of [Debian](https://wiki.debian.org/DebianReleases) and indicate which release the image is based on. If your image needs to install any additional packages beyond what comes with the image, you'll likely want to specify one of these explicitly to minimize breakage when there are new releases of Debian.

# License
View [license information](http://openjdk.java.net/legal/gplv2+ce.html) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

Some additional license information which was able to be auto-detected might be found in [the repo-info repository's openjdk/ directory](https://github.com/docker-library/repo-info/tree/master/repos/openjdk).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.