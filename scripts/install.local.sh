#!/bin/bash

cd ../programs/postgresql
sh install.sh
cd ../../scripts
echo ""
echo ""

cd ../programs/mysql
sh install.sh
cd ../../scripts
echo ""
echo ""

cd ../programs/mongodb
sh install.sh
cd ../../scripts
echo ""
echo ""

cd ../programs/elasticsearch
sh install.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-data-migrations
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-identity-data-migrations
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-identity
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-composer
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-donors-feed
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-images-feed
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-specimens-feed
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-genome-feed
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-ensembl-data
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-ensembl-vep
sh install.local.sh
cd ../../scripts
echo ""
echo ""
