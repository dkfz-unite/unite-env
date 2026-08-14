#!/bin/bash

# Stop all running unite* containers
docker ps -a | grep unite | awk '{print $1}' | xargs -r docker stop

# Remove all unite* containers
docker ps -a | grep unite | awk '{print $1}' | xargs -r docker rm

# Remove all unite* images
# Awoid this: WARNING: This output is designed for human readability. For machine-readable output, please use --format.
docker images --format '{{.Repository}}:{{.Tag}}' | grep 'unite' | xargs -r docker rmi

# Clean Elasticsearch
docker stop es
docker rm es
docker volume rm es.data

# Clean Mongo
docker stop mongo
docker rm mongo
docker volume rm mongo.data
docker volume rm mongo.config

# Clean analysis data
docker volume rm unite.analysis.data

# Remove postgres database unite_domain
docker restart pgsql
docker exec -it pgsql psql -c "DROP DATABASE IF EXISTS unite_data;"