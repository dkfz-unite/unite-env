#!/bin/bash
dbr=113_GRCh37

chmod 700 ./data

tput setaf 4; echo "# Extracting VEP cache"; tput sgr0
tar -xvf ./data/homo_sapiens_vep_$dbr.tar.gz -C ./data
echo ""
