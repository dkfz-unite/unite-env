#!/bin/bash
dbn=113
dbr="$dbn"_"GRCh38"

if [ ! -d "./data" ]
then
  mkdir data
  chmod 666 data
fi

tput setaf 4; echo "# Downloading VEP cache"; tput sgr0
wget -c -O ./data/homo_sapiens_vep_$dbr.tar.gz http://ftp.ensembl.org/pub/release-$dbn/variation/vep/homo_sapiens_vep_$dbr.tar.gz
echo ""
