#!/bin/sh
# Runs a service from its published image.
# Usage (from its folder, e.g. applications/unite-composer):
#   sh ../../scripts/app/deploy.sh <key>
# UNITE_PROJECT sets the Compose project (default: unite).

key=${1:?"Usage: deploy.sh <key>, e.g. composer"}
var=$(echo "$key" | tr 'a-z-' 'A-Z_')
project=${UNITE_PROJECT:-unite}

# Local, uncommitted changes to .env (gitignored), applied after it.
envlocal=""
[ -f ../../.env.local ] && envlocal="--env-file ../../.env.local"

# Local, uncommitted changes to the compose configuration (gitignored), applied last.
override=""
[ -f docker-compose.override.yml ] && override="-f docker-compose.override.yml"

# .env with the local changes from .env.local; .env.local is also read first,
# so that UNITE_SOURCE_PATH_PREFIX set there is used for the source paths in .env.
[ -f ../../.env.local ] && . ../../.env.local
. ../../.env
[ -f ../../.env.local ] && . ../../.env.local
eval "name=\${UNITE_${var}_NAME:-$key}"

tput setaf 6; echo "# Installing $name"; tput sgr0
echo ""

tput setaf 4; echo "# Pulling and running docker image"; tput sgr0
COMPOSE_IGNORE_ORPHANS=true docker compose -p "$project" --env-file ../../.env $envlocal --env-file ../../.env.secrets \
  -f docker-compose.yml $override up -d
