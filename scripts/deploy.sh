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

cd ../applications/unite-feed-omics
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

cd ../applications/unite-analysis-de
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis-scell
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis-surv
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis-dm
sh deploy.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis-pcam
sh deploy.sh
cd ../../scripts
echo ""
echo ""