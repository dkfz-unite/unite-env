#!/bin/bash

set -a; . ../../.env.secrets; set +a

docker exec -it mysql mysql -u $UNITE_MYSQL_USER -p$UNITE_MYSQL_PASSWORD
