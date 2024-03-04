#!/bin/bash

cd ../programs/postgresql
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../programs/mysql
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../programs/mongodb
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../programs/elasticsearch
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-data-migrations
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-identity-data-migrations
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-identity
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-composer
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-donors-feed
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-images-feed
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-specimens-feed
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-genome-feed
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-ensembl-data
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-ensembl-vep
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis-deseq2
sh deploy.sh
cd ../../scripts
echo ""
echo ""
