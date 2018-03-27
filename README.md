# Fetch Debian packages

To do a simple fetch of a list of Debian packages and all their dependencies:

```plain
docker run -v $PWD/tmp/apt-cache:/apt-cache \
  starkandwayne/fetch-debian-packages:trusty /scripts/fetch.sh \
  tree
```

To describe additional Apt repositories, then create an `apt.json` and pass in via `/apt-config/apt.json`:

```plain
cat > tmp/apt.json <<JSON
{
  "packages": ["tree"]
}
JSON

docker run \
  -v $PWD/tmp/apt-cache:/apt-cache \
  -v $PWD/tmp/apt.json:/apt-config/apt.json \
  starkandwayne/fetch-debian-packages:trusty /scripts/fetch.sh
```

To build:

```plain
docker build -t starkandwayne/fetch-debian-packages:trusty -f Dockerfile.trusty .
```