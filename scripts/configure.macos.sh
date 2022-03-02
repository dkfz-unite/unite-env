#!/bin/bash

sh configure.sh
echo ""

tput setaf 6; echo "# Creating docker network 'unite'"; tput sgr0
docker network create unite
