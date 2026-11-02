#!/bin/bash
. ../../scripts/ensembl.sh

chmod 700 ./cache

cd ./cache/core$grch
tput setaf 4; echo "# Extracting Ensembl core database cache"; tput sgr0
for file in *.gz; do gunzip "$file"; done
echo ""
cd ../../

# cd ./cache/func$grch
# tput setaf 4; echo "# Extracting Ensembl functional genome database cache"; tput sgr0
# for file in *.gz; do gunzip "$file"; done
# echo ""
# cd ../../
