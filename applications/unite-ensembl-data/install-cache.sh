#!/bin/bash
set -e

. ../../scripts/ensembl.sh
. ../../.env.secrets

export MYSQL_PWD="$UNITE_MYSQL_PASSWORD"

docker run --rm \
  --platform linux/amd64 \
  --network unite \
  --mount "type=bind,source=$(pwd)/cache,target=/cache,readonly" \
  --mount "type=bind,source=$(pwd)/migrations,target=/migrations,readonly" \
  --env MYSQL_PWD \
  --env MYSQL_HOST="$UNITE_MYSQL_HOST" \
  --env MYSQL_PORT="$UNITE_MYSQL_PORT" \
  --env MYSQL_USER="$UNITE_MYSQL_USER" \
  --env ENSEMBL_DATABASE="homo_sapiens_core_${release}_${grch}" \
  --env ENSEMBL_CACHE="/cache/core${grch}" \
  --entrypoint /bin/bash \
  mysql:5.6 -ec '
    echo "# Creating Ensembl core database"
    mysql --host="$MYSQL_HOST" --port="$MYSQL_PORT" --user="$MYSQL_USER" \
      -e "CREATE DATABASE $ENSEMBL_DATABASE"

    echo "# Restoring Ensembl core database schema"
    mysql --host="$MYSQL_HOST" --port="$MYSQL_PORT" --user="$MYSQL_USER" \
      "$ENSEMBL_DATABASE" < "$ENSEMBL_CACHE/$ENSEMBL_DATABASE.sql"

    echo "# Restoring Ensembl core database data"
    mysqlimport --host="$MYSQL_HOST" --port="$MYSQL_PORT" --user="$MYSQL_USER" \
      --local \
      --fields-terminated-by="\t" \
      --fields-escaped-by="\\" \
      "$ENSEMBL_DATABASE" "$ENSEMBL_CACHE"/*.txt

    echo "# Applying Ensembl core database migrations"
    mysql --host="$MYSQL_HOST" --port="$MYSQL_PORT" --user="$MYSQL_USER" \
      "$ENSEMBL_DATABASE" < /migrations/00001.sql
  '
