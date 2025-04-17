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
echo ""
