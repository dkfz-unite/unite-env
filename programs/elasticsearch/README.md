# Elasticsearch Service

Elasticsearch service serves the follwing purposes:
- Indices storage - stores different type-centric indices of available data
- Search engine - provides powerful API for processing of cross reference search queries

## Files

Folder contains the following files:
- `docker-compose.yml` - Elasticsearch server configuration file
- `docker-compose.mgmt.yml` - Elasticsearch management tools (Kibana) configuration file
- `deploy.sh` - Elasticsearch server installation script
- `install.mgmt.sh` - Elasticsearch management tools (Kibana) installation script

## Before Installation

- Ensure **`secrets.json`** is configured as described [here](https://github.com/dkfz-unite/unite-environment#secrets)
- Ensure docker network '**unite**' is created

## Installation

Open this sfolder in terminal and run required command:
- To install Elasticsearch server
  ```bash
  sh deploy.sh
  ```
- To install Elasticsearch management tools (optional)
  ```bash
  sh install.mgmt.sh
  ```

## Services

|Service|Container|Alias|Container Port|Host Port|
|:------|:--------|:----|:---|:---------|
|Elasticsearch|es|es.unite.net|9200|9200|
|Kibana|es.mgmt|mgmt.es.unite.net|5601|8083|

All components are running in docker network '**unite**'.
