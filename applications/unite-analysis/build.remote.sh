#!/bin/bash

branch=${1:-main}
ghb_usr=$(jq -r .github.user ../../secrets.json)
ghb_tkn=$(jq -r .github.token ../../secrets.json)
sql_usr=$(jq -r .sql.user ../../secrets.json)
sql_pwd=$(jq -r .sql.password ../../secrets.json)
els_usr=$(jq -r .elasticsearch.user ../../secrets.json)
els_pwd=$(jq -r .elasticsearch.password ../../secrets.json)
mon_usr=$(jq -r .mongodb.user ../../secrets.json)
mon_pwd=$(jq -r .mongodb.password ../../secrets.json)
api_key=$(jq -r .api.key ../../secrets.json)

tput setaf 6; echo "# Installing UNITE Analysis service"; tput sgr0
echo ""

tput setaf 4; echo "# Cleaning up source code directory"; tput sgr0
rm -r -f src
echo ""

tput setaf 4; echo "# Cloning fresh code to source code directory (branch: $branch)"; tput sgr0
git clone --single-branch --depth 1 --branch "$branch" https://$ghb_tkn@github.com/dkfz-unite/unite-analysis.git src
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
GITHUB_USER=$ghb_usr \
GITHUB_TOKEN=$ghb_tkn \
ELASTIC_USER=$els_usr \
ELASTIC_PASSWORD=$els_pwd \
SQL_USER=$sql_usr \
SQL_PASSWORD=$sql_pwd \
MONGO_USER=$mon_usr \
MONGO_PASSWORD=$mon_pwd \
API_KEY=$api_key \
docker compose -p 'unite' -f docker-compose.build.yml up -d --build