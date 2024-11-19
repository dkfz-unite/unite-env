#!/bin/bash

ghb_usr=$(jq -r .github.user ../../secrets.json)
ghb_tkn=$(jq -r .github.token ../../secrets.json)

tput setaf 6; echo "# Installing UNITE analysis service (Single Cell Viewer)"; tput sgr0
echo ""

tput setaf 4; echo "# Cleaning up source code directory"; tput sgr0
rm -r -f src
echo ""

tput setaf 4; echo "# Cloning fresh code to source code directory"; tput sgr0
git clone https://$ghb_tkn@github.com/dkfz-unite/unite-analysis-scell-view.git src
echo ""

tput setaf 4; echo "# Building docker image"; tput sgr0
GITHUB_USER=$ghb_usr \
GITHUB_TOKEN=$ghb_tkn \
docker compose -p '' -f docker-compose.build.yml build -d