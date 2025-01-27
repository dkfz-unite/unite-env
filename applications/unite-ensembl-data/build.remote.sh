#!/bin/bash

ghb_tkn=$(jq -r .github.token ../../secrets.json)
sql_usr=$(jq -r .sql.user ../../secrets.json)
sql_pwd=$(jq -r .sql.password ../../secrets.json)

tput setaf 6; echo "# Installing Ensembl Genome Data service"; tput sgr0
echo ""

tput setaf 4; echo "# Cleaning up source code directory"; tput sgr0
rm -r -f src
echo ""

tput setaf 4; echo "# Cloning fresh code to source code directory"; tput sgr0
git clone https://$ghb_tkn@github.com/dkfz-unite/unite-ensembl-data.git src
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
SQL_USER=$sql_usr \
SQL_PASSWORD=$sql_pwd \
docker compose -p 'unite' -f docker-compose.build.yml up -d --build
