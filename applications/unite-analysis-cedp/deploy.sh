#!/bin/bash

tput setaf 6; echo "# Installing UNITE analysis service (Proterin Expression Distribution)"; tput sgr0
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
docker compose -p 'unite' --env-file ../../.env --env-file ../../.env.secrets -f docker-compose.yml up -d --build