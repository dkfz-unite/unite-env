#!/bin/bash

cd ../programs/postgresql
sh install.mgmt.sh
cd ../../scripts
echo ""
echo ""

cd ../programs/mongodb
sh install.mgmt.sh
cd ../../scripts
echo ""
echo ""

cd ../programs/elasticsearch
sh install.mgmt.sh
cd ../../scripts
echo ""
echo ""

