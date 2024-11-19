#!/bin/bash

src_pth=$(jq -r .SourceCodeDirectoryPath ../../config.json)

tput setaf 6; echo "# Installing UNITE analysis service (Single Cell Viewer)"; tput sgr0
echo ""

tput setaf 4; echo "# Cleaning up source code directory"; tput sgr0
rm -r -f src
echo ""

tput setaf 4; echo "# Cloning fresh code to source code directory"; tput sgr0
mkdir src
cp -r $src_pth/unite-analysis-scell-view/. src/
echo ""

tput setaf 4; echo "# Building docker image"; tput sgr0
docker compose -p '' -f docker-compose.build.yml build -d