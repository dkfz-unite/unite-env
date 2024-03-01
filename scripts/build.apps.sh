#!/bin/bash

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

cd ../applications/unite-donors-feed
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-images-feed
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-specimens-feed
sh build.remote.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-genome-feed
sh build.remote.sh
cd ../../scripts
echo ""
echo ""
