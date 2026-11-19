#!/bin/sh
# Runs inside the temporary MySQL client container, from /setup.
set -e

release=$ENSEMBL_RELEASE
. ./cache.sh

query()
{
  mysql --host="$MYSQL_HOST" --port="$MYSQL_PORT" --user="$MYSQL_USER" \
    --batch --skip-column-names "$@"
}

for genome in 37 38
do
  configure_cache "$genome"
  exists=$(query -e "SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name = '$cache_database'")
  if [ "$exists" = 0 ]
  then
    echo "# Creating Ensembl GRCh$genome database and schema"
    query -e "CREATE DATABASE $cache_database"
    query "$cache_database" < "$cache_directory/$cache_database.sql"
  fi

  for table in $cache_tables
  do
    populated=$(query "$cache_database" -e "SELECT EXISTS(SELECT 1 FROM $table LIMIT 1)")
    if [ "$populated" = 1 ]
    then
      echo "# Reusing Ensembl GRCh$genome table $table"
      continue
    fi

    echo "# Importing Ensembl GRCh$genome table $table"
    mysqlimport --host="$MYSQL_HOST" --port="$MYSQL_PORT" --user="$MYSQL_USER" \
      --local \
      --fields-terminated-by='\t' \
      --fields-escaped-by='\\' \
      "$cache_database" "$cache_directory/$table.txt"
  done

  index_exists=$(query -e "SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = '$cache_database' AND table_name = 'object_xref' AND index_name = 'ensembl_object_type_xref_id'")
  if [ "$index_exists" = 0 ]
  then
    echo "# Applying Ensembl GRCh$genome annotation adjustments"
    query "$cache_database" < ./migrations/00001.sql
  fi
done
