#!/bin/bash

cd ../applications/unite-data-migrations
sh install.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-identity-data-migrations
sh install.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite
sh install.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-identity
sh install.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-composer
sh install.sh
cd ../../scripts
echo ""
echo ""

cd ../applicationsunite-analysis
sh install.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-donors-feed
sh install.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-images-feed
sh install.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-specimens-feed
sh install.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-genome-feed
sh install.sh
cd ../../scripts
echo ""
echo ""
