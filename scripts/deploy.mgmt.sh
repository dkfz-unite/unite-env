#!/bin/bash

cd ../programs/postgresql
sh deploy.mgmt.sh
cd ../../scripts
echo ""
echo ""

cd ../programs/mongodb
sh deploy.mgmt.sh
cd ../../scripts
echo ""
echo ""

cd ../programs/elasticsearch
sh deploy.mgmt.sh
cd ../../scripts
echo ""
echo ""

