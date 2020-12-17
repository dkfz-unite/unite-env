#!/bin/bash

tput setaf 6; echo "# Removing all containers"; tput sgr0
docker rm -f $(docker container ls -aq)
echo ""

tput setaf 6; echo "# Removing all volumes"; tput sgr0
docker volume prune -f
echo ""

tput setaf 6; echo "# Cleaning up MySQL data"; tput sgr0
rm -r -f ../programs/mysql/data
echo ""

tput setaf 6; echo "# Cleaning up MongoDB data"; tput sgr0
rm -r -f ../programs/mongodb/data
echo ""

tput setaf 6; echo "# Cleaning up unused images and networks"; tput sgr0
docker system prune -f
 