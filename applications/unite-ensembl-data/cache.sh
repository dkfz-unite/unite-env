#!/bin/sh
# Shared cache selection for download, extraction and import.
# The caller supplies the Ensembl release. Both builds use the same table list.

if [ "$#" -gt 0 ]
then
  echo "Usage: sh $0 (no arguments; prepares both genome builds)" >&2
  exit 1
fi

configure_cache()
{
  cache_database="homo_sapiens_core_${release}_$1"
  cache_directory="./cache/core$1"
  cache_url="https://ftp.ensembl.org/pub/release-$release/mysql/$cache_database"
  if [ "$1" = 37 ]
  then
    cache_url="https://ftp.ensembl.org/pub/grch37/release-$release/mysql/$cache_database"
  fi

  cache_tables=$(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' ./tables.txt)

  cache_files="$cache_database.sql"
  for table in $cache_tables
  do
    cache_files="$cache_files $table.txt"
  done
}
