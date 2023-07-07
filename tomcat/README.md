# Quick reference

- Maintained by:  
    [the Docker Community](https://github.com/wojiushixiaobai/docker-library-loong64)

- Where to get help:  
    [the Docker Community Slack](https://dockr.ly/comm-slack), [Server Fault](https://serverfault.com/help/on-topic), [Unix & Linux](https://unix.stackexchange.com/help/on-topic), or [Stack Overflow](https://stackoverflow.com/help/on-topic)

# Supported tags and respective Dockerfile links
- [10.1-jdk17-buster, 10.1-jdk17](https://github.com/docker-library/tomcat/blob/2b200acb84bebc3e867f32e3b64f19620aa60b58/8.5/jdk8/corretto-al2/Dockerfile)
- [10.1-jdk11-buster, 10.1-jdk11](https://github.com/docker-library/tomcat/blob/2b200acb84bebc3e867f32e3b64f19620aa60b58/8.5/jdk8/corretto-al2/Dockerfile)
- [9.0-jdk17-buster, 9.0-jdk17](https://github.com/docker-library/tomcat/blob/2b200acb84bebc3e867f32e3b64f19620aa60b58/8.5/jdk8/corretto-al2/Dockerfile)
- [9.0-jdk11-buster, 9.0-jdk11](https://github.com/docker-library/tomcat/blob/2b200acb84bebc3e867f32e3b64f19620aa60b58/8.5/jdk8/corretto-al2/Dockerfile)
- [9.0-jdk8-buster, 9.0-jdk8](https://github.com/docker-library/tomcat/blob/2b200acb84bebc3e867f32e3b64f19620aa60b58/8.5/jdk8/corretto-al2/Dockerfile)
- [8.5-jdk17-buster, 8.5-jdk17](https://github.com/docker-library/tomcat/blob/2b200acb84bebc3e867f32e3b64f19620aa60b58/8.5/jdk8/corretto-al2/Dockerfile)
- [8.5-jdk11-buster, 8.5-jdk11](https://github.com/docker-library/tomcat/blob/2b200acb84bebc3e867f32e3b64f19620aa60b58/8.5/jdk8/corretto-al2/Dockerfile)
- [8.5-jdk8-buster, 8.5-jdk8](https://github.com/docker-library/tomcat/blob/2b200acb84bebc3e867f32e3b64f19620aa60b58/8.5/jdk8/corretto-al2/Dockerfile)

# Quick reference (cont.)

- Where to file issues:  
    [https://github.com/wojiushixiaobai/docker-library-loong64/issues](https://github.com/wojiushixiaobai/docker-library-loong64/issues?q=)

- Supported architectures: ([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
    amd64, arm64, loong64

# What is Tomcat?

Apache Tomcat (or simply Tomcat) is an open source web server and servlet container developed by the Apache Software Foundation (ASF). Tomcat implements the Java Servlet and the JavaServer Pages (JSP) specifications from Oracle, and provides a "pure Java" HTTP web server environment for Java code to run in. In the simplest config Tomcat runs in a single operating system process. The process runs a Java virtual machine (JVM). Every single HTTP request from a browser to Tomcat is processed in the Tomcat process in a separate thread.

    [wikipedia.org/wiki/Apache_Tomcat](https://en.wikipedia.org/wiki/Apache_Tomcat)

![logo](https://raw.githubusercontent.com/docker-library/docs/master/tomcat/logo.png) Logo © Apache Software Fountation

# How to use this image.

Note: as of [docker-library/tomcat#181](https://github.com/docker-library/tomcat/pull/181), the upstream-provided (example) webapps are not enabled by default, per [upstream's security recommendations](https://tomcat.apache.org/tomcat-9.0-doc/security-howto.html#Default_web_applications), but are still available under the `webapps.dist` folder within the image to make them easier to re-enable.

Run the default Tomcat server (`CMD ["catalina.sh", "run"]`):
```
$ docker run -it --rm jumpserver/tomcat:9.0-jdk17
```
You can test it by visiting `http://container-ip:8080` in a browser or, if you need access outside the host, on port 8888:
```
$ docker run -it --rm -p 8888:8080 jumpserver/tomcat:9.0-jdk17
```
You can then go to `http://localhost:8888` or `http://host-ip:8888` in a browser (noting that it will return a 404 since there are no webapps loaded by default).

The default Tomcat environment in the image is:
```
CATALINA_BASE:   /usr/local/tomcat
CATALINA_HOME:   /usr/local/tomcat
CATALINA_TMPDIR: /usr/local/tomcat/temp
JRE_HOME:        /usr
CLASSPATH:       /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar
```
The configuration files are available in `/usr/local/tomcat/conf/`. By default, no user is included in the "manager-gui" role required to operate the "/manager/html" web application. If you wish to use this app, you must define such a user in `tomcat-users.xml`.

# Image Variants

The `jumpserver/tomcat` images come in many flavors, each designed for a specific use case.

## jumpserver/tomcat:<version>

This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is designed to be used both as a throw away container (mount your source code and start the container to start your app), as well as the base to build other images off of.

Some of these tags may have names like bookworm or bullseye in them. These are the suite code names for releases of [Debian](https://wiki.debian.org/DebianReleases) and indicate which release the image is based on. If your image needs to install any additional packages beyond what comes with the image, you'll likely want to specify one of these explicitly to minimize breakage when there are new releases of Debian.

Some of these tags may have names like focal or jammy in them. These are the suite code names for releases of [Ubuntu](https://wiki.ubuntu.com/Releases) and indicate which release the image is based on. If your image needs to install any additional packages beyond what comes with the image, you'll likely want to specify one of these explicitly to minimize breakage when there are new releases of Ubuntu.

# License

View [license information](https://www.apache.org/licenses/LICENSE-2.0) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

Some additional license information which was able to be auto-detected might be found in [the repo-info repository's tomcat/ directory](https://github.com/docker-library/repo-info/tree/master/repos/tomcat).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.