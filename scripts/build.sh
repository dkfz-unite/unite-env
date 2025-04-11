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
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-identity-data-migrations
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-identity
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-composer
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-feed-donors
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-feed-images
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-feed-specimens
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-feed-genome
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-ensembl-data
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-ensembl-vep
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis-don-sce
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis-meth-dm
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis-rna-de
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis-rnasc-dc
sh build.remote.sh
cd ../../scripts
echo ""
echo ""
