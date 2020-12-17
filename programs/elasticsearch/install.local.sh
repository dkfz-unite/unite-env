#!/bin/bash

usr=$(jq -r .elasticsearch.user ../../secrets.json)
pwd=$(jq -r .elasticsearch.password ../../secrets.json)

tput setaf 6; echo "# Installing Elasticsearch (LOCAL)"; tput sgr0
USER=$usr PASSWORD=$pwd docker-compose -p '' -f docker-compose.local.yml up -d
echo ""

tput setaf 4; echo "# Waiting for Elasticsearch node to warm up"; tput sgr0
echo ""
sleep 10

tput setaf 4; echo "# Connecting Elasticsearch master node to 'unite' network with alias 'es.unite'"; tput sgr0
docker network connect unite --alias es.unite es01