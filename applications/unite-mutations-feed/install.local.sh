#!/bin/bash

ghb_usr=$(jq -r .github.user ../../secrets.json)
ghb_tkn=$(jq -r .github.token ../../secrets.json)
sql_usr=$(jq -r .mysql.user ../../secrets.json)
sql_pwd=$(jq -r .mysql.password ../../secrets.json)
els_usr=$(jq -r .elasticsearch.user ../../secrets.json)
els_pwd=$(jq -r .elasticsearch.password ../../secrets.json)

tput setaf 6; echo "# Installing UNITE Mutations Datafeed service (LOCAL)"; tput sgr0
echo ""

tput setaf 4; echo "# Cleaning up source code directory"; tput sgr0
rm -r -f src
echo ""

tput setaf 4; echo "# Cloning fresh code to source code directory"; tput sgr0
git clone https://$ghb_tkn@github.com/dkfz-unite/unite-mutations-feed.git src
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
GITHUB_USER=$ghb_usr \
GITHUB_TOKEN=$ghb_tkn \
ELASTIC_USER=$els_usr \
ELASTIC_PASSWORD=$els_pwd \
MYSQL_USER=$sql_usr \
MYSQL_PASSWORD=$sql_pwd \
docker-compose -p '' -f docker-compose.local.yml up -d --build