#!/bin/bash

. ../../.env.secrets

docker exec -it es curl -u $UNITE_ELASTIC_USER:$UNITE_ELASTIC_PASSWORD -s http://127.0.0.1:9200/_nodes/_local/stats/jvm | jq '.nodes[].jvm.mem'
