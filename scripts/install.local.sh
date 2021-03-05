#!/bin/bash

cd ../programs/postgresql
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

cd ../applications/unite-data-migrations
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