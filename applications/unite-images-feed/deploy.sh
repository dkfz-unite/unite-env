#!/bin/bash

sql_usr=$(jq -r .sql.user ../../secrets.json)
sql_pwd=$(jq -r .sql.password ../../secrets.json)
els_usr=$(jq -r .elasticsearch.user ../../secrets.json)
els_pwd=$(jq -r .elasticsearch.password ../../secrets.json)
mon_usr=$(jq -r .mongodb.user ../../secrets.json)
mon_pwd=$(jq -r .mongodb.password ../../secrets.json)
api_key=$(jq -r .api.key ../../secrets.json)

tput setaf 6; echo "# Installing UNITE Images Datafeed service"; tput sgr0
echo ""


tput setaf 4; echo "# Building and running docker image"; tput sgr0
ELASTIC_USER=$els_usr \
ELASTIC_PASSWORD=$els_pwd \
SQL_USER=$sql_usr \
SQL_PASSWORD=$sql_pwd \
MONGO_USER=$mon_usr \
MONGO_PASSWORD=$mon_pwd \
API_KEY=$api_key \
docker compose -p 'unite' -f docker-compose.yml up -d --build
