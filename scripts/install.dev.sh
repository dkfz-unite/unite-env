#!/bin/bash

cd ../programs/postgresql
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

cd ../applications/unite-data-migrations
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
