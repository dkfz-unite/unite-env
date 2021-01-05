#!/bin/bash

tput setaf 6; echo "# Creating docker network 'unite'"; tput sgr0
docker network create unite
echo ""
echo ""

cd ../programs/mysql
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../programs/mongodb
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../programs/elasticsearch
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-migrations
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-composer
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-donors-feed
sh install.local.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-mutations-feed
sh install.local.sh
cd ../../scripts
echo ""
echo ""