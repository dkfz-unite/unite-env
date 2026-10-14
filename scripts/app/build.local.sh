#!/bin/sh
# Copies a service's local source and builds and runs it.
# Usage (from its folder, e.g. applications/unite-composer):
#   sh ../../scripts/app/build.local.sh <key>
# UNITE_PROJECT sets the Compose project (default: unite).

key=${1:?"Usage: build.local.sh <key>, e.g. composer"}
var=$(echo "$key" | tr 'a-z-' 'A-Z_')
project=${UNITE_PROJECT:-unite}

. ../../.env.services
[ -f ../../.env.services.local ] && . ../../.env.services.local
eval "name=\${UNITE_${var}_NAME:-$key}; path=\${UNITE_${var}_PATH}"
[ -d "$path" ] || { echo "Source folder '$path' of '$key' not found: set UNITE_SOURCE_PATH_PREFIX or UNITE_${var}_PATH"; exit 1; }

case $(docker version --format '{{.Server.Arch}}') in
  arm64) rid=linux-arm64;;
  *) rid=linux-x64;;
esac

tput setaf 6; echo "# Installing $name"; tput sgr0
echo ""

tput setaf 4; echo "# Copying local source from $path"; tput sgr0
rm -rf src
cp -r "$path" src || exit 1
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
COMPOSE_IGNORE_ORPHANS=true RID=$rid docker compose -p "$project" --env-file ../../.env --env-file ../../.env.secrets \
  -f docker-compose.yml -f docker-compose.build.yml up -d --build
