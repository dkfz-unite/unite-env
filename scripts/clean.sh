#!/bin/bash

delete_images=false
if [ "${1-}" = "-i" ]; then
    delete_images=true
    shift
fi

if [ "$#" -ne 0 ]; then
    echo "Usage: sh clean.sh [-i] (-i also removes UNITE Docker images)" >&2
    exit 2
fi

# Stop all running unite* containers
docker ps -a | grep unite | awk '{print $1}' | xargs -r docker stop

# Remove all unite* containers
docker ps -a | grep unite | awk '{print $1}' | xargs -r docker rm

# Remove all unite* images
if [ "$delete_images" = true ]; then
    docker images --format '{{.Repository}}:{{.Tag}}' | grep 'unite' | xargs -r docker rmi
fi

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

# Remove PostgreSQL database unite_data
docker restart pgsql || exit 1

attempts=0
until docker exec pgsql sh -c 'pg_isready -q -t 1 -U "$POSTGRES_USER" -d postgres'; do
    attempts=$((attempts + 1))
    if [ "$attempts" -ge 10 ]; then
        echo "PostgreSQL in pgsql is still unavailable after 10 checks. Check docker logs pgsql." >&2
        exit 1
    fi
    sleep 1
done

docker exec pgsql sh -c 'psql -U "$POSTGRES_USER" -d postgres -c "DROP DATABASE IF EXISTS unite_data;"'
