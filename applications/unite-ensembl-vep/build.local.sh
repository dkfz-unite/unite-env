#!/bin/bash

src_pth=$(jq -r .SourceCodeDirectoryPath ../../config.json)

tput setaf 6; echo "# Installing UNITE VEP Annotations service"; tput sgr0
echo ""

tput setaf 4; echo "# Cleaning up source code directory"; tput sgr0
rm -r -f src
echo ""

tput setaf 4; echo "# Cloning fresh code to source code directory"; tput sgr0
mkdir src
cp -r $src_pth/unite-ensembl-vep/. src/
echo ""

ARCH=$(docker version --format '{{.Server.Arch}}')
case "$ARCH" in
  "amd64") RID="linux-x64";;
  "arm64") RID="linux-arm64";;
  *) RID="linux-x64";;
esac

tput setaf 4; echo "# Building and running docker image"; tput sgr0
RID=$RID \
docker compose -p 'unite' -f docker-compose.build.yml up -d --build
