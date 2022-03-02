#!/bin/bash

usr=$(jq -r .elasticsearch.user ../../secrets.json)
pwd=$(jq -r .elasticsearch.password ../../secrets.json)

tput setaf 6; echo "# Installing Elasticsearch"; tput sgr0
USER=$usr \
PASSWORD=$pwd \
docker-compose -p '' -f docker-compose.yml up -d