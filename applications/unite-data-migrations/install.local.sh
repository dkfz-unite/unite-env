#!/bin/bash

src_pth=$(jq -r .SourceCodeDirectoryPath ../../config.json)
ghb_usr=$(jq -r .github.user ../../secrets.json)
ghb_tkn=$(jq -r .github.token ../../secrets.json)
sql_usr=$(jq -r .sql.user ../../secrets.json)
sql_pwd=$(jq -r .sql.password ../../secrets.json)

tput setaf 6; echo "# Installing UNITE Data Migrations service"; tput sgr0
echo ""

tput setaf 4; echo "# Cleaning up source code directory"; tput sgr0
rm -r -f src
echo ""

tput setaf 4; echo "# Cloning fresh code to source code directory"; tput sgr0
mkdir src
cp -r $src_pth/unite-data-migrations/. src/
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
GITHUB_USER=$ghb_usr \
GITHUB_TOKEN=$ghb_tkn \
SQL_USER=$sql_usr \
SQL_PASSWORD=$sql_pwd \
docker-compose -p '' -f docker-compose.local.yml up -d --build
