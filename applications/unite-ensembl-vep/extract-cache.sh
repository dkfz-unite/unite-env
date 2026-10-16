#!/bin/bash
. ../../scripts/ensembl.sh
dbr="$release"_GRCh"$grch"

chmod 700 ./data

tput setaf 4; echo "# Extracting VEP cache"; tput sgr0
tar -xvf ./data/homo_sapiens_vep_$dbr.tar.gz -C ./data
echo ""
