#!/bin/bash

sh configure.dev.sh
echo ""

tput setaf 6; echo "# Setting up kernel setting 'vm.max_map_count' to minimal required value of '262144'"; tput sgr0
sysctl -w vm.max_map_count=262144