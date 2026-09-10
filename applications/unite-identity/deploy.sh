#!/bin/bash

mon_usr=$(jq -r .mongo.user ../../secrets.json)
mon_pwd=$(jq -r .mongo.password ../../secrets.json)
sql_usr=$(jq -r .sql.user ../../secrets.json)
sql_pwd=$(jq -r .sql.password ../../secrets.json)
api_key=$(jq -r .api.key ../../secrets.json)
adm_usr=$(jq -r .admin.user ../../secrets.json)
adm_pwd=$(jq -r .admin.password ../../secrets.json)

tput setaf 6; echo "# Installing UNITE Identity service"; tput sgr0
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
MONGO_USER=$mon_usr \
MONGO_PASSWORD=$mon_pwd \
SQL_USER=$sql_usr \
SQL_PASSWORD=$sql_pwd \
API_KEY=$api_key \
ADMIN_USER=$adm_usr \
ADMIN_PASSWORD=$adm_pwd \
docker compose -p 'unite' -f docker-compose.yml up -d --build
