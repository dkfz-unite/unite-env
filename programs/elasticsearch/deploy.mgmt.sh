#!/bin/bash

usr=$(jq -r .elasticsearch.user ../../secrets.json)
pwd=$(jq -r .elasticsearch.password ../../secrets.json)

tput setaf 6; echo "# Installing Elasticsearch management tools"; tput sgr0
USER=$usr \
PASSWORD=$pwd \
docker compose -p 'unite-env' -f docker-compose.mgmt.yml up -d