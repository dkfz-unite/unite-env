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

tput setaf 6; echo "# Removing all images"; tput sgr0
docker image rm -f $(docker image ls -aq)
echo ""

tput setaf 6; echo "# Removing 'unite' network"; tput sgr0
docker network rm unite
echo ""
