#!/bin/bash

api_key=$(jq -r .api.key ../../secrets.json)

tput setaf 6; echo "# Installing UNITE Web application"; tput sgr0
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
API_KEY=$api_key \
docker compose -p 'unite' -f docker-compose.yml up -d --build