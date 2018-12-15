Docker Images
----------------
[![Travis Build](https://travis-ci.com/gokit/docker.svg?branch=master)](https://travis-ci.org/gokit/docker#)

This repository is a collection of useful docker based image files which can be generated for use in tests or for building/compiling
related programs. They exists as base to be used for such function, the generated images for some are rather large and not advisable 
to be used in production but only for testing, developing or pilot deployments.


## Building

Building supports the use of debian and alpine images.

By default `alpine` is always built when running the commands without the `BASE` and `DIR`
environment variables set.

Running the `make build` command will be all available docker files using provided
version in tag and user name to be used for tagging and pushing to docker hub.

- Building for alpine

```bash
VERSION=0.0.1 DUSER=wombat make build
```

or

```bash
VERSION=0.0.1 DUSER=wombat BASE=alpine DIR=alpine make build
```

- Building for debian 

```bash
VERSION=0.0.1 DUSER=wombat BASE=debian DIR=debian make build
```

You can generate builds for custom go versions and custom google components for gcloud docker
images by customizing the `GOVERSION` and `COMPONENTS` environment variables to your needs.

```bash
GOVERSION=1.11.2 COMPONENTS=pubsub-emulator make build
```

The above only builds all images for the go version `1.11.2` and only the gcloud 
component `pubsub-emulator`.

The `GOVERSION` and `COMPONENTS` make variables can be set to list items which are strings 
seperated by space like below:

```bash
COMPONENTS = app-engine-go cbt bigtable datalab cloud-datastore-emulator gcd-emulator cloud-firestore-emulator pubsub-emulator cloud_sql_proxy emulator-reverse-proxy cloud-build-local docker-credential-gcr kubectl GOVERSION = 1.11.2 1.11.1 1.11 1.10 1.9 1.8 1.7 make build
```

The command above will build all seperated versions and components in a loop accordingly.
