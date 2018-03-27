#!/bin/bash


set -eu
baseDir=${baseDir:-/apt-cache}
sourceList="$baseDir/apt/sources/sources.list"
trustedKeys="$baseDir/apt/etc/trusted.gpg"
cacheDir="$baseDir/apt/cache"
stateDir="$baseDir/apt/state"
options="-o debug::nolocking=true -o dir::cache=$cacheDir -o dir::state=$stateDir -o dir::etc::sourcelist=$sourceList -o dir::etc::trusted=$trustedKeys"

set -x
mkdir -p "$(dirname $sourceList)"
mkdir -p "$(dirname $trustedKeys)"
mkdir -p "$cacheDir"
mkdir -p "$stateDir"
cp /etc/apt/sources.list "$sourceList"
cp /etc/apt/trusted.gpg "$trustedKeys"


if [[ ! -f /apt-config/apt.json ]]; then
  packages=$@
  echo "No /apt-config/apt.json found, looking for: $packages"
else
  packages=$(jq -r ".packages[]" /apt-config/apt.json)
fi

apt-get update ${options}
apt-get install ${options} -y $packages
