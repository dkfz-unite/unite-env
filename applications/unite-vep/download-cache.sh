#!/bin/bash

if [ ! -d "./data" ] 
then
  mkdir data
fi

wget -c -O ./data/homo_sapiens_vep_103_GRCh37.tar.gz http://ftp.ensembl.org/pub/release-103/variation/vep/homo_sapiens_vep_103_GRCh37.tar.gz
