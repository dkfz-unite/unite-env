#!/bin/bash
dbr=108

if [ ! -d "./data" ] 
then
  mkdir data
fi

wget -c -O ./data/homo_sapiens_vep_$dbr_GRCh37.tar.gz http://ftp.ensembl.org/pub/release-$dbr/variation/vep/homo_sapiens_vep_$dbr_GRCh37.tar.gz
