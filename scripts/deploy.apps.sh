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
