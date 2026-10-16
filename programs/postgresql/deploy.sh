#!/bin/bash

# Local, uncommitted changes to .env (gitignored), applied after it.
envlocal=""
[ -f ../../.env.local ] && envlocal="--env-file ../../.env.local"

tput setaf 6; echo "# Installing Postgresql"; tput sgr0
COMPOSE_IGNORE_ORPHANS=true docker compose -p 'unite-env' --env-file ../../.env $envlocal --env-file ../../.env.secrets -f docker-compose.yml up -d