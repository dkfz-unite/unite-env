#!/bin/bash

sh uninstall.soft.sh
echo ""

tput setaf 6; echo "# Removing all volumes"; tput sgr0
docker volume prune -f
echo ""

tput setaf 6; echo "# Removing all images"; tput sgr0
docker image rm -f $(docker image ls -aq)
echo ""