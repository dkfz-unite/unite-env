#!/bin/sh
set -e

. ../../scripts/ensembl.sh
. ./cache.sh

for genome in 37 38
do
  configure_cache "$genome"
  for file in $cache_files
  do
    if [ ! -f "$cache_directory/$file" ] && [ ! -f "$cache_directory/$file.gz" ]
    then
      echo "Missing cache file: $cache_directory/$file.gz. Run download-cache.sh first." >&2
      exit 1
    fi
  done
done

chmod 700 ./cache

for genome in 37 38
do
  configure_cache "$genome"
  echo "# Extracting Ensembl GRCh$genome cache"
  for file in $cache_files
  do
    if [ ! -f "$cache_directory/$file" ]
    then
      gunzip "$cache_directory/$file.gz"
    fi
  done
done
