#!/bin/bash

tput setaf 6; echo "# Installing UNITE Migrations service (DEV)"; tput sgr0
echo ""

ghb_usr=$(jq -r .github.user ../../secrets.json)
ghb_tkn=$(jq -r .github.token ../../secrets.json)
sql_usr=$(jq -r .mysql.user ../../secrets.json)
sql_pwd=$(jq -r .mysql.password ../../secrets.json)

tput setaf 4; echo "# Cleaning up source code directory"; tput sgr0
rm -r -f src
echo ""

tput setaf 4; echo "# Cloning fresh code to source code directory"; tput sgr0
git clone https://github.com/dkfz-unite/unite-data-migrations.git src
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
GITHUB_USER=$ghb_usr GITHUB_TOKEN=$ghb_tkn MYSQL_USER=$sql_usr MYSQL_PASSWORD=$sql_pwd docker-compose -p '' -f docker-compose.dev.yml up -d --build