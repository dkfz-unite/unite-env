#!/bin/bash

tput setaf 6; echo "# Removing all containers"; tput sgr0
docker rm -f $(docker container ls -aq)
echo ""

tput setaf 6; echo "# Cleaning up unused images and networks"; tput sgr0
docker system prune -f