#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: sh export-secrets.sh <path/to/secrets.json>"
    exit 1
fi

if ! [ -f "$1" ]; then
    echo "Error: File '$1' does not exist."
    exit 1
fi

export GITHUB_USER=$(jq -r .github.user "$1")
export GITHUB_TOKEN=$(jq -r .github.token "$1")
export SQL_USER=$(jq -r .sql.user "$1")
export SQL_PASSWORD=$(jq -r .sql.password "$1")
export ELASTIC_USER=$(jq -r .elasticsearch.user "$1")
export ELASTIC_PASSWORD=$(jq -r .elasticsearch.password "$1")
export MONGO_USER=$(jq -r .mongodb.user "$1")
export MONGO_PASSWORD=$(jq -r .mongodb.password "$1")
export API_KEY=$(jq -r .api.key "$1")
