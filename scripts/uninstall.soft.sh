#!/bin/bash

tput setaf 6; echo "# Removing all containers"; tput sgr0
docker rm -f $(docker container ls -aq)
echo ""

tput setaf 6; echo "# Cleaning up unpammed images"; tput sgr0
docker image prune -f

tput setaf 6; echo "# Removing 'unite' network"; tput sgr0
docker network rm unite
echo ""
