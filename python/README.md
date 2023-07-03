# Quick reference
- Maintained by:  
[the Docker Community](https://github.com/wojiushixiaobai/docker-library-loong64)

## Simple Tags
- [3.11-slim-buster, 3.11-slim](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/python/3.11/slim-buster/Dockerfile)
- [3.10-slim-buster, 3.10-slim](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/python/3.10/slim-buster/Dockerfile)
- [3.9-slim-buster, 3.9-slim](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/python/3.9/slim-buster/Dockerfile)
- [3.8-slim-buster, 3.8-slim](https://github.com/wojiushixiaobai/docker-library-loong64/blob/master/python/3.8/slim-buster/Dockerfile)

# Quick reference (cont.)
- Where to file issues:  
[https://github.com/wojiushixiaobai/docker-library-loong64/issues](https://github.com/wojiushixiaobai/docker-library-loong64/issues?q=)

- Supported architectures: ([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64))  
amd64, arm64, loong64

# What is Python?
Python is an interpreted, interactive, object-oriented, open-source programming language. It incorporates modules, exceptions, dynamic typing, very high level dynamic data types, and classes. Python combines remarkable power with very clear syntax. It has interfaces to many system calls and libraries, as well as to various window systems, and is extensible in C or C++. It is also usable as an extension language for applications that need a programmable interface. Finally, Python is portable: it runs on many Unix variants, on the Mac, and on Windows 2000 and later.

[wikipedia.org/wiki/Python_(programming_language)](https://en.wikipedia.org/wiki/Python_%28programming_language%29)

![logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/python/logo.png)

# How to use this image
## Create a `Dockerfile` in your Python app project
```
FROM jumpserver/python:3.9

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./your-daemon-or-script.py" ]
```
or (if you need to use Python 3.8):
```
FROM jumpserver/python:3.8

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./your-daemon-or-script.py" ]
```
You can then build and run the Docker image:
```
$ docker build -t my-python-app .
$ docker run -it --rm --name my-running-app my-python-app
```
## Run a single Python script
For many simple, single file projects, you may find it inconvenient to write a complete `Dockerfile`. In such cases, you can run a Python script by using the Python Docker image directly:
```
$ docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp python:3 python your-daemon-or-script.py
```

## Multiple Python versions in the image
In the non-slim variants there will be an additional (distro-provided) `python` executable at `/usr/bin/python` (and/or `/usr/bin/python3`) while the desired image-provided `/usr/local/bin/python` is the default choice in the `$PATH`. This is an unfortunate side-effect of using the `buildpack-deps` image in the non-slim variants (and many distribution-provided tools being written against and likely to break with a different Python installation, so we can't safely remove/overwrite it).

# Image Variants
The `jumpserver/python` images come in many flavors, each designed for a specific use case.

## jumpserver/python:<version>
This is the defacto image. If you are unsure about what your needs are, you probably want to use this one. It is designed to be used both as a throw away container (mount your source code and start the container to start your app), as well as the base to build other images off of.

Some of these tags may have names like bookworm or bullseye in them. These are the suite code names for releases of [Debian](https://wiki.debian.org/DebianReleases) and indicate which release the image is based on. If your image needs to install any additional packages beyond what comes with the image, you'll likely want to specify one of these explicitly to minimize breakage when there are new releases of Debian.

This tag is based off of [buildpack-deps](https://hub.docker.com/_/buildpack-deps/). `buildpack-deps` is designed for the average user of Docker who has many images on their system. It, by design, has a large number of extremely common Debian packages. This reduces the number of packages that images that derive from it need to install, thus reducing the overall size of all images on your system.

## jumpserver/python:<version>-slim
This image does not contain the common packages contained in the default tag and only contains the minimal packages needed to run `python`. Unless you are working in an environment where only the `python` image will be deployed and you have space constraints, we highly recommend using the default image of this repository.

# License
View license information for [Python 2](https://docs.python.org/2/license.html) and [Python 3](https://docs.python.org/3/license.html).

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

Some additional license information which was able to be auto-detected might be found in [the repo-info repository's python/ directory](https://github.com/docker-library/repo-info/tree/master/repos/python).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.