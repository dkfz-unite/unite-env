#!/bin/bash

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

cd ../applications/unite-analysis-deseq2
sh deploy.sh
cd ../../scripts
echo ""
echo ""
