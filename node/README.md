# Quick reference
- Maintained by:  
[The Node.js Docker Team](https://github.com/wojiushixiaobai/docker-library-loong64)

# Supported tags and respective Dockerfile links
- [18.13-buster-slim, 18.13](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/node/18.13/buster-slim/Dockerfile)
- [16.17-buster-slim, 16.17](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/node/16.17/buster-slim/Dockerfile)
- [16.5-buster-slim, 16.5](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/node/16.5/buster-slim/Dockerfile)
- [16.3-buster-slim, 16.3](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/node/16.3/buster-slim/Dockerfile)
- [14.16-buster-slim, 14.16](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/node/14.16/buster-slim/Dockerfile)
- [12.19-buster-slim, 12.19](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/node/12.19/buster-slim/Dockerfile)
- [10.24-buster-slim, 10.24](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/node/10.24/buster-slim/Dockerfile)

# Quick reference (cont.)
- Where to file issues:  
[https://github.com/wojiushixiaobai/docker-library-loong64](https://github.com/wojiushixiaobai/docker-library-loong64?q=)

- Supported architectures: ([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
amd64, arm64, loong64

# What is Node.js?
Node.js is a software platform for scalable server-side and networking applications. Node.js applications are written in JavaScript and can be run within the Node.js runtime on Mac OS X, Windows, and Linux without changes.

Node.js applications are designed to maximize throughput and efficiency, using non-blocking I/O and asynchronous events. Node.js applications run single-threaded, although Node.js uses multiple threads for file and network events. Node.js is commonly used for real-time applications due to its asynchronous nature.

Node.js internally uses the Google V8 JavaScript engine to execute code; a large percentage of the basic modules are written in JavaScript. Node.js contains a built-in, asynchronous I/O library for file, socket, and HTTP communication. The HTTP and socket support allows Node.js to act as a web server without additional software such as Apache.

[wikipedia.org/wiki/Node.js](https://en.wikipedia.org/wiki/Node.js)

![logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/node/logo.png)

# How to use this image
See [How To Use This Image](https://github.com/nodejs/docker-node/blob/master/README.md#how-to-use-this-image) on GitHub for up-to-date documentation.

# Image Variants
The `jumpserver/node` images come in many flavors, each designed for a specific use case.

## jumpserver/node:<version>-slim
This image does not contain the common packages contained in the default tag and only contains the minimal packages needed to run `node`. Unless you are working in an environment where only the `node` image will be deployed and you have space constraints, we highly recommend using the default image of this repository.

# License
View [license information](https://github.com/nodejs/node/blob/master/LICENSE) for Node.js or [license information](https://github.com/nodejs/docker-node/blob/master/LICENSE) for the Node.js Docker project.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

Some additional license information which was able to be auto-detected might be found in [the repo-info repository's node/ directory](https://github.com/docker-library/repo-info/tree/master/repos/node).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.