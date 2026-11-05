#!/bin/sh
# Runs inside the temporary MySQL client container, from /setup.
set -e

release=$ENSEMBL_RELEASE
grch=$ENSEMBL_GENOME
. ./cache.sh

query()
{
  mysql --host="$MYSQL_HOST" --port="$MYSQL_PORT" --user="$MYSQL_USER" \
    --batch --skip-column-names "$@"
}

# Check both databases before creating either one during a fresh installation.
if [ "$mode" = all ]
then
  for genome in 37 38
  do
    configure_cache "$genome"
    exists=$(query -e "SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name = '$cache_database'")
    if [ "$exists" != 0 ]
    then
      echo "Database $cache_database already exists. Use 'sh install-cache.sh sequence' to add sequence data." >&2
      exit 1
    fi
  done
fi

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

  # Default sequence tables have unique keys. Ignore existing keys when extending
  # an installation, preserving its rows and allowing interrupted loads to retry.
  import_option=
  if [ "$mode" = sequence ]
  then
    import_option=--ignore
  fi

  set --
  for table in $cache_tables
  do
    set -- "$@" "$cache_directory/$table.txt"
  done

  echo "# Importing Ensembl GRCh$genome table data"
  mysqlimport --host="$MYSQL_HOST" --port="$MYSQL_PORT" --user="$MYSQL_USER" \
    --local $import_option \
    --fields-terminated-by='\t' \
    --fields-escaped-by='\\' \
    "$cache_database" "$@"

  if [ "$mode" = all ] && [ "$genome" = "$grch" ]
  then
    echo "# Applying Ensembl GRCh$genome annotation adjustments"
    query "$cache_database" < ./migrations/00001.sql
  fi
done
