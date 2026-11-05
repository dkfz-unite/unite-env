#!/bin/sh
# Shared cache selection for download, extraction and import.
# The caller supplies release and grch (the installation's annotation build).

mode=${1:-all}
if [ "$#" -gt 1 ]
then
  echo "Usage: sh $0 [all|sequence]" >&2
  exit 1
fi

case "$mode" in
  all|sequence) ;;
  *) echo "Usage: sh $0 [all|sequence]" >&2; exit 1;;
esac

configure_cache()
{
  cache_database="homo_sapiens_core_${release}_$1"
  cache_directory="./cache/core$1"
  cache_url="https://ftp.ensembl.org/pub/release-$release/mysql/$cache_database"
  if [ "$1" = 37 ]
  then
    cache_url="https://ftp.ensembl.org/pub/grch37/release-$release/mysql/$cache_database"
  fi

  cache_list=./tables-sequence.txt
  if [ "$mode" = all ] && [ "$1" = "$grch" ]
  then
    cache_list=./tables-annotation.txt
  fi
  cache_tables=$(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$cache_list")

  cache_files="$cache_database.sql"
  for table in $cache_tables
  do
    cache_files="$cache_files $table.txt"
  done
}
