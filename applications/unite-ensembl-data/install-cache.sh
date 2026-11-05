#!/bin/sh
set -e

. ../../scripts/ensembl.sh
. ./cache.sh

for genome in 37 38
do
  configure_cache "$genome"
  for file in $cache_files
  do
    if [ ! -f "$cache_directory/$file" ]
    then
      echo "Missing cache file: $cache_directory/$file. Run download-cache.sh and extract-cache.sh first." >&2
      exit 1
    fi
  done
done

. ../../.env.secrets
export MYSQL_PWD="$UNITE_MYSQL_PASSWORD"

docker run --rm \
  --platform linux/amd64 \
  --network unite \
  --mount "type=bind,source=$(pwd),target=/setup,readonly" \
  --workdir /setup \
  --env MYSQL_PWD \
  --env MYSQL_HOST="$UNITE_MYSQL_HOST" \
  --env MYSQL_PORT="$UNITE_MYSQL_PORT" \
  --env MYSQL_USER="$UNITE_MYSQL_USER" \
  --env ENSEMBL_RELEASE="$release" \
  --env ENSEMBL_GENOME="$grch" \
  --entrypoint /bin/sh \
  mysql:5.6 /setup/import-cache.sh "$mode"
