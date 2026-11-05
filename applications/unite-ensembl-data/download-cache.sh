#!/bin/sh
set -e

. ../../scripts/ensembl.sh
. ./cache.sh

for genome in 37 38
do
  configure_cache "$genome"
  mkdir -p "$cache_directory"

  echo "# Downloading Ensembl GRCh$genome cache"
  for file in $cache_files
  do
    if [ ! -f "$cache_directory/$file" ]
    then
      wget -c -O "$cache_directory/$file.gz" "$cache_url/$file.gz"
    fi
  done
done
