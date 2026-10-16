#!/bin/bash
. ../../scripts/ensembl.sh
dbr="$release"_GRCh"$grch"

if [ ! -d "./data" ]
then
  mkdir data
  chmod 666 data
fi

tput setaf 4; echo "# Downloading VEP cache"; tput sgr0
wget -c -O ./data/homo_sapiens_vep_$dbr.tar.gz $ftp/variation/indexed_vep_cache/homo_sapiens_vep_$dbr.tar.gz
echo ""
