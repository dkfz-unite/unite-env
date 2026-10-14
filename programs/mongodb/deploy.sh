#!/bin/bash

tput setaf 6; echo "# Installing Mongodb"; tput sgr0
COMPOSE_IGNORE_ORPHANS=true docker compose -p 'unite-env' --env-file ../../.env --env-file ../../.env.secrets -f docker-compose.yml up -d