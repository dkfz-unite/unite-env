#!/bin/bash

usr=$(jq -r .mongodb.user ../../secrets.json)
pwd=$(jq -r .mongodb.password ../../secrets.json)

tput setaf 6; echo "# Installing Mongodb"; tput sgr0
USER=$usr \
PASSWORD=$pwd \
docker-compose -p '' -f docker-compose.yml up -d