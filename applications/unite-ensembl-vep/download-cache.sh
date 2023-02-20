#!/bin/bash
dbn=108
dbr="$dbn"_"GRCh37"

if [ ! -d "./data" ] 
then
  mkdir data
fi

wget -c -O ./data/homo_sapiens_vep_$dbr.tar.gz http://ftp.ensembl.org/pub/release-$dbn/variation/vep/homo_sapiens_vep_$dbr.tar.gz
