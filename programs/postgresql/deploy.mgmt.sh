#!/bin/bash

tput setaf 6; echo "# Installing Postgresql management tools"; tput sgr0
docker compose -p 'unite-env' --env-file ../../.env --env-file ../../.env.secrets -f docker-compose.mgmt.yml up -d