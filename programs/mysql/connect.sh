#!/bin/bash

usr=$(jq -r .sql.user ../../secrets.json)
pwd=$(jq -r .sql.password ../../secrets.json)

docker exec -it mysql mysql -u $usr -p$pwd