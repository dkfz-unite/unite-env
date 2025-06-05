#!/bin/bash

chmod 700 ./cache

cd ./cache/core37
tput setaf 4; echo "# Extracting Ensembl core database cache"; tput sgr0
for file in *.gz; do gunzip "$file"; done
echo ""
cd ../../

# cd ./cache/func37
# tput setaf 4; echo "# Extracting Ensembl functional genome database cache"; tput sgr0
# for file in *.gz; do gunzip "$file"; done
# echo ""
# cd ../../
