# Quick reference
- Maintained by:  
[the Docker Community](https://github.com/wojiushixiaobai/docker-library-loong64)

Supported tags and respective Dockerfile links
- [3.9.3-openjdk-17-slim](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/maven/openjdk-17-slim/Dockerfile)
- [3.9.3-openjdk-11-slim](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/maven/openjdk-11-slim/Dockerfile)
- [3.9.3-openjdk-8-slim](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/maven/openjdk-8-slim/Dockerfile)

# Quick reference (cont.)
- Where to file issues:  
[https://github.com/wojiushixiaobai/docker-library-loong64/issues](https://github.com/wojiushixiaobai/docker-library-loong64/issues?q=)

- Supported architectures: ([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
amd64, arm64, loong64

Source of this description:
[docs repo's maven/ directory](https://github.com/docker-library/docs/tree/master/maven) ([history](https://github.com/docker-library/docs/commits/master/maven))

# What is Maven?
[Apache Maven](http://maven.apache.org/) is a software project management and comprehension tool. Based on the concept of a project object model (POM), Maven can manage a project's build, reporting and documentation from a central piece of information.

![logo](https://raw.githubusercontent.com/docker-library/docs/e2782b8942c1af41419536078c8d0176665a005d/maven/logo.png)

# How to use this image
You can run a Maven project by using the Maven Docker image directly, passing a Maven command to docker run:
```
$ docker run -it --rm --name my-maven-project -v "$(pwd)":/usr/src/mymaven -w /usr/src/mymaven jumpserver/maven:3.9.3-openjdk-8-slim mvn clean install
```
## Building local Docker image (optional)
This is a base image that you can extend, so it has the bare minimum packages needed. If you add custom package(s) to the `Dockerfile`, then you can build your local Docker image like this:
```
$ docker build --tag my_local_maven:3.5.2-jdk-8 .
```
# Reusing the Maven local repository
The local Maven repository can be reused across containers by creating a volume and mounting it in `/root/.m2`.
```
$ docker volume create --name maven-repo
$ docker run -it -v maven-repo:/root/.m2 maven mvn archetype:generate # will download artifacts
$ docker run -it -v maven-repo:/root/.m2 maven mvn archetype:generate # will reuse downloaded artifacts
```
Or you can just use your home .m2 cache directory that you share e.g. with your Eclipse/IDEA:
```
$ docker run -it --rm -v "$PWD":/usr/src/mymaven -v "$HOME/.m2":/root/.m2 -v "$PWD/target:/usr/src/mymaven/target" -w /usr/src/mymaven maven mvn clean package  
```

# Packaging a local repository with the image
The `$MAVEN_CONFIG` dir (default to `/root/.m2`) could be configured as a volume so anything copied there in a Dockerfile at build time is lost. For that reason the dir `/usr/share/maven/ref/` exists, and anything in that directory will be copied on container startup to `$MAVEN_CONFIG`.

To create a pre-packaged repository, create a `pom.xml` with the dependencies you need and use this in your Dockerfile. `/usr/share/maven/ref/settings-docker.xml` is a settings file that changes the local repository to `/usr/share/maven/ref/repository`, but you can use your own settings file as long as it uses `/usr/share/maven/ref/repository` as local repo.

```
COPY pom.xml /tmp/pom.xml
RUN mvn -B -f /tmp/pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:resolve
```
To add your custom `settings.xml` file to the image use

```
COPY settings.xml /usr/share/maven/ref/
```
For an example, check the `tests` dir

# Running as non-root
Maven needs the user home to download artifacts to, and if the user does not exist in the image an extra user.home Java property needs to be set.

For example, to run as user `1000` mounting the host' Maven repo
```
$ docker run -v ~/.m2:/var/maven/.m2 -ti --rm -u 1000 -e MAVEN_CONFIG=/var/maven/.m2 maven mvn -Duser.home=/var/maven archetype:generate
```
# Image Variants
The `jumpserver/maven` images come in many flavors, each designed for a specific use case.

## jumpserver/maven:<version>
This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is designed to be used both as a throw away container (mount your source code and start the container to start your app), as well as the base to build other images off of.

Some of these tags may have names like bookworm in them. These are the suite code names for releases of [Debian](https://wiki.debian.org/DebianReleases) and indicate which release the image is based on. If your image needs to install any additional packages beyond what comes with the image, you'll likely want to specify one of these explicitly to minimize breakage when there are new releases of Debian.

Some of these tags may have names like focal in them. These are the suite code names for releases of [Ubuntu](https://wiki.ubuntu.com/Releases) and indicate which release the image is based on. If your image needs to install any additional packages beyond what comes with the image, you'll likely want to specify one of these explicitly to minimize breakage when there are new releases of Ubuntu.

# License
View [license information](https://www.apache.org/licenses/) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

Some additional license information which was able to be auto-detected might be found in [the repo-info repository's maven/ directory](https://github.com/docker-library/repo-info/tree/master/repos/maven).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.