#!/bin/bash

tput setaf 6; echo "# Installing UNITE analysis service (Single Cell Viewer)"; tput sgr0
echo ""

tput setaf 4; echo "# Pulling docker image"; tput sgr0
docker compose -p '' -f docker-compose.local.yml pull