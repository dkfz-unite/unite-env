#!/bin/bash

pwd=$(jq -r .mysql.password ../../secrets.json)

tput setaf 6; echo "# Installing MySQL (DEV)"; tput sgr0
PASSWORD=$pwd \
docker-compose -p '' -f docker-compose.dev.yml up -d