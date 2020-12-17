#!/bin/bash

pwd=$(jq -r .mysql.password ../../secrets.json)

tput setaf 6; echo "# Installing MySQL (LOCAL)"; tput sgr0
PASSWORD=$pwd docker-compose -p '' -f docker-compose.local.yml up -d