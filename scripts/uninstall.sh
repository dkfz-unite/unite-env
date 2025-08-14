#!/bin/bash

sh uninstall.soft.sh
echo ""

tput setaf 6; echo "# Removing all volumes"; tput sgr0
docker volume rm -f \
es.data \
mongo.config \
mongo.data \
mysql.data \
pgsql.data \
unite.analysis.data
echo ""
