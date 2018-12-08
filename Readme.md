Docker Images
----------------
This repository is a collection of useful docker based image files which can be generated for use in tests or for building/compiling
related programs. They exists as base to be used for such function, the generated images for some are rather large and not advisable 
to be used in production but only for testing, developing or pilot deployments.


## Building

Running the `make build` command will be all available docker files using provided
version in tag and user name to be used for tagging and pushing to docker hub.

```bash
VERSION=0.0.1 DUSER=wombat make build
```

```bash
VERSION=0.0.1 DUSER=wombat make push
```