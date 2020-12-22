#!/bin/bash

ssl_pwd=$(jq -r .ssl.password ../../secrets.json)

tput setaf 6; echo "# Installing UNITE Web application (DEV)"; tput sgr0
echo ""

tput setaf 4; echo "# Cleaning up source code directory"; tput sgr0
rm -r -f src
echo ""

tput setaf 4; echo "# Cloning fresh code to source code directory"; tput sgr0
git clone https://github.com/dkfz-unite/unite.git src
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
SSL_PASSWORD=$ssl_pwd \
docker-compose -p '' -f docker-compose.dev.yml up -d --build