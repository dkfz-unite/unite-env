#!/bin/bash

tput setaf 6; echo "# Removing all containers"; tput sgr0
docker rm -f $(docker container ls -aq)
echo ""

tput setaf 6; echo "# Cleaning up unused images"; tput sgr0
docker image prune -f

docker network rm unite.elastic