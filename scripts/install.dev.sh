#!/bin/bash

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
