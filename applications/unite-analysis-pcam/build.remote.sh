#!/bin/bash

set -a; . ../../.env.secrets; set +a
branch=${1:-main}

tput setaf 6; echo "# Installing UNITE analysis service (Methylation Arrays Principal Components Analysis)"; tput sgr0
echo ""

tput setaf 4; echo "# Cleaning up source code directory"; tput sgr0
rm -r -f src
echo ""

tput setaf 4; echo "# Cloning fresh code to source code directory (branch: $branch)"; tput sgr0
git clone --single-branch --depth 1 --branch "$branch" https://$UNITE_GITHUB_TOKEN@github.com/dkfz-unite/unite-analysis-pcam.git src
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
docker compose -p 'unite' --env-file ../../.env --env-file ../../.env.secrets -f docker-compose.yml -f docker-compose.build.yml up -d --build