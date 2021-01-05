#!/bin/bash

echo "# Cleaning up source code directory"
rm -r -f src

echo "# Cloning fresh code to source code directory"
git clone https://b240-phabricator.dkfz-heidelberg.de/diffusion/346/unite-mutations-datafeed.git src

echo "# Installing UNITE Mutations Datafeed service (DEV)"
docker-compose -p '' -f docker-compose.dev.yml up -d --build