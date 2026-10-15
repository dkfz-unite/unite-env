#!/bin/bash

. ../../.env.secrets

docker exec -it mysql mysql -u $UNITE_MYSQL_USER -p$UNITE_MYSQL_PASSWORD
