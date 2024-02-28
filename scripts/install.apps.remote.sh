#!/bin/bash

cd ../applications/unite-data-migrations
sh install.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-identity-data-migrations
sh install.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite
sh install.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-identity
sh install.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-composer
sh install.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-analysis
sh install.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-donors-feed
sh install.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-images-feed
sh install.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-specimens-feed
sh install.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-genome-feed
sh install.remote.sh
cd ../../scripts
echo ""
echo ""
