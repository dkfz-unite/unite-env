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

chains_directory="./cache/chains"
mkdir -p "$chains_directory"

download_chain()
{
  file="$1"
  url="$2"
  destination="$chains_directory/$file"
  partial="$destination.part"

  if [ ! -f "$destination" ]
  then
    wget -c -O "$partial" "$url"
    mv "$partial" "$destination"
  fi
}

echo "# Downloading genome liftover chains"
download_chain "hg19ToHg38.over.chain.gz" "https://hgdownload.soe.ucsc.edu/goldenPath/hg19/liftOver/hg19ToHg38.over.chain.gz"
download_chain "hg38ToHg19.over.chain.gz" "https://hgdownload.soe.ucsc.edu/goldenPath/hg38/liftOver/hg38ToHg19.over.chain.gz"
