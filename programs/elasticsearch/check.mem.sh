#!/bin/bash

usr=$(jq -r .elasticsearch.user ../../secrets.json)
pwd=$(jq -r .elasticsearch.password ../../secrets.json)

docker exec -it es curl -u $usr:$pwd -s http://127.0.0.1:9200/_nodes/_local/stats/jvm | jq '.nodes[].jvm.mem'