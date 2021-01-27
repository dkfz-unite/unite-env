#!/bin/bash

tput setaf 6; echo "# Creating docker network 'unite'"; tput sgr0
docker network create unite -o "com.docker.network.driver.mtu=1450"
echo ""
echo ""

cd ../programs/mysql
sh install.dev.sh
cd ../../scripts
echo ""
echo ""

cd ../programs/mongodb
sh install.dev.sh
cd ../../scripts
echo ""
echo ""

cd ../programs/elasticsearch
sh install.dev.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-migrations
sh install.dev.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite
sh install.dev.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-composer
sh install.dev.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-donors-feed
sh install.dev.sh
cd ../../scripts
echo ""
echo ""

cd ../applications/unite-mutations-feed
sh install.dev.sh
cd ../../scripts
echo ""
echo ""
