#!/bin/sh
# Clones a service's repository and builds and runs it.
# Usage (from its folder, e.g. applications/unite-composer):
#   sh ../../scripts/app/build.remote.sh <key> [branch]
# Branch: argument, else <KEY>_BRANCH, else the repository's default branch.
# UNITE_PROJECT sets the Compose project (default: unite).

key=${1:?"Usage: build.remote.sh <key> [branch], e.g. composer"}
var=$(echo "$key" | tr 'a-z-' 'A-Z_')
project=${UNITE_PROJECT:-unite}

# Local, uncommitted changes to the compose configuration (gitignored), applied last.
override=""
[ -f docker-compose.override.yml ] && override="-f docker-compose.override.yml"

. ../../.env.services
[ -f ../../.env.services.local ] && . ../../.env.services.local
. ../../.env.secrets
eval "name=\${UNITE_${var}_NAME:-$key}; url=\${UNITE_${var}_URL}; branch=\${2:-\${UNITE_${var}_BRANCH}}"
[ -n "$url" ] || { echo "No URL for '$key': set UNITE_${var}_URL in .env.services"; exit 1; }

case $(docker version --format '{{.Server.Arch}}') in
  arm64) rid=linux-arm64;;
  *) rid=linux-x64;;
esac

# The GitHub token is sent only to github.com, as a header (not stored in the URL).
auth=""
[ -n "$UNITE_GITHUB_TOKEN" ] && auth="AUTHORIZATION: basic $(printf 'x-access-token:%s' "$UNITE_GITHUB_TOKEN" | base64 | tr -d '\n')"

tput setaf 6; echo "# Installing $name"; tput sgr0
echo ""

tput setaf 4; echo "# Cloning $url (branch: ${branch:-default})"; tput sgr0
rm -rf src
if [ -n "$branch" ]; then
  git -c http.https://github.com/.extraheader="$auth" clone --depth 1 --branch "$branch" "$url" src || exit 1
else
  git -c http.https://github.com/.extraheader="$auth" clone --depth 1 "$url" src || exit 1
fi
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
COMPOSE_IGNORE_ORPHANS=true RID=$rid docker compose -p "$project" --env-file ../../.env --env-file ../../.env.secrets \
  -f docker-compose.yml -f docker-compose.build.yml $override up -d --build
