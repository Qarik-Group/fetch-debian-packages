# Fetch Debian packages

```plain
docker run -v $PWD/tmp/apt-cache:/apt-cache \
  starkandwayne/fetch-debian-packages:trusty /scripts/fetch.sh \
  git
```

To build:

```plain
docker build -t starkandwayne/fetch-debian-packages:trusty -f Dockerfile.trusty .
```