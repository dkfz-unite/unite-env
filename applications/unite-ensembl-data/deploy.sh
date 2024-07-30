#!/bin/bash

sql_usr=$(jq -r .sql.user ../../secrets.json)
sql_pwd=$(jq -r .sql.password ../../secrets.json)

tput setaf 6; echo "# Installing Ensembl Genome Data service"; tput sgr0
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
SQL_USER=$sql_usr \
SQL_PASSWORD=$sql_pwd \
docker compose -p '' -f docker-compose.yml up -d --build
