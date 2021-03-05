#!/bin/bash

usr=$(jq -r .sql.user ../../secrets.json)
pwd=$(jq -r .sql.password ../../secrets.json)

tput setaf 6; echo "# Installing PostgreSQL (DEV)"; tput sgr0
USER=$usr \
PASSWORD=$pwd \
docker-compose -p '' -f docker-compose.dev.yml up -d