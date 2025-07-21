#!/bin/bash

tput setaf 6; echo "# Installing UNITE analysis service (Methylation Arrays Principal Components Analysis)"; tput sgr0
echo ""

tput setaf 4; echo "# Building and running docker image"; tput sgr0
docker compose -p 'unite' -f docker-compose.local.yml up -d --build