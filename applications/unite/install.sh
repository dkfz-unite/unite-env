#!/bin/bash

ghb_tkn=$(jq -r .github.token ../../secrets.json)

tput setaf 6; echo "# Installing UNITE Web application"; tput sgr0
echo ""

tput setaf 4; echo "# Cleaning up source code directory"; tput sgr0
rm -r -f src
echo ""

tput setaf 4; echo "# Cloning fresh code to source code directory"; tput sgr0
git clone https://$ghb_tkn@github.com/dkfz-unite/unite.git src
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
docker-compose -p '' -f docker-compose.yml up -d --build --quiet
