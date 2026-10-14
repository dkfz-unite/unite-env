#!/bin/bash

. ../../.env.secrets

tput setaf 6; echo "# Installing Elasticsearch management tools"; tput sgr0

# Kibana connects as the built-in kibana_system user with the elastic password.
tput setaf 4; echo "# Setting kibana_system password"; tput sgr0
docker exec es curl -s -f -u "$UNITE_ELASTIC_USER:$UNITE_ELASTIC_PASSWORD" \
  -X POST http://127.0.0.1:9200/_security/user/kibana_system/_password \
  -H 'Content-Type: application/json' \
  -d "{\"password\":\"$UNITE_ELASTIC_PASSWORD\"}" > /dev/null \
  || { echo "Could not set the kibana_system password; is Elasticsearch running?"; exit 1; }
echo ""

tput setaf 4; echo "# Starting Kibana"; tput sgr0
COMPOSE_IGNORE_ORPHANS=true docker compose -p 'unite-env' --env-file ../../.env --env-file ../../.env.secrets -f docker-compose.mgmt.yml up -d
