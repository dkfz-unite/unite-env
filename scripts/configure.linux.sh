#!/bin/bash

sh configure.sh
echo ""

tput setaf 6; echo "# Setting up kernel setting 'vm.max_map_count' to minimal required value of '262144'"; tput sgr0
sysctl -w vm.max_map_count=262144

tput setaf 6; echo "# Creating docker network 'unite'"; tput sgr0
docker network create unite -o "com.docker.network.driver.mtu=1450"