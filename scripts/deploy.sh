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

cd ../applications/unite-feed-donors
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-feed-images
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-feed-specimens
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-feed-genome
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

cd ../applications/unite-analysis-don-sce
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis-meth-dm
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis-rna-de
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis-rnasc-dc
sh deploy.sh
cd ../../scripts
echo ""
echo ""
