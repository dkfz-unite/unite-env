#!/bin/bash

tput setaf 6; echo "# Adding secrets.json to local ignore list"; tput sgr0
git update-index --assume-unchanged ../secrets.json
git update-index --skip-worktree ../secrets.json
echo ""

tput setaf 6; echo "# Changing secrets.json permissions to 600"; tput sgr0
chmod 600 ../secrets.json
echo ""

tput setaf 6; echo "# Creating docker network 'unite'"; tput sgr0
docker network create unite -o "com.docker.network.driver.mtu=1450"
