#!/bin/bash


set -eu
baseDir=${baseDir:-/apt-cache}
sourceList="$baseDir/apt/sources/sources.list"
trustedKeys="$baseDir/apt/etc/trusted.gpg"
cacheDir="$baseDir/apt/cache"
stateDir="$baseDir/apt/state"
options="-o debug::nolocking=true -o dir::cache=$cacheDir -o dir::state=$stateDir -o dir::etc::sourcelist=$sourceList -o dir::etc::trusted=$trustedKeys"

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
  keys=$(jq -r ".keys[]" /apt-config/apt.json)
  repos=$(jq -r ".repos[]" /apt-config/apt.json)
  packages=$(jq -r ".packages[]" /apt-config/apt.json)
fi

for keyURL in "${keys[@]}"; do
  curl -L $keyURL | apt-key --keyring $trustedKeys adv -
done

for repo in "${repos[@]}"; do
  echo "$repo" >> $sourceList
done

set -x
# apt-get update ${options}
# apt-get install ${options} -y $packages
