#!/bin/bash

branch=${1:-main}
ghb_usr=$(jq -r .github.user ../../secrets.json)
ghb_tkn=$(jq -r .github.token ../../secrets.json)

tput setaf 6; echo "# Installing UNITE analysis service (Differential Methylation)"; tput sgr0
echo ""

tput setaf 4; echo "# Cleaning up source code directory"; tput sgr0
rm -r -f src
echo ""

tput setaf 4; echo "# Cloning fresh code to source code directory (branch: $branch)"; tput sgr0
git clone --single-branch --depth 1 --branch "$branch" https://$ghb_tkn@github.com/dkfz-unite/unite-analysis-dm.git src
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
GITHUB_USER=$ghb_usr \
GITHUB_TOKEN=$ghb_tkn \
docker compose -p 'unite' -f docker-compose.build.yml up -d --build