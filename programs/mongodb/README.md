# Mongodb Service

Mongodb service serves the follwing purposes:
- Technical data storage - stores the data, required by other services interracton

## Files

Folder contains the following files:
- `docker-compose.yml` - Mongodb server configuration file
- `docker-compose.mgmt.yml` - Mongodb management tools (Mongo Express) configuration file
- `deploy.sh` - Mongodb server installation script
- `deploy.mgmt.sh` - Mongodb management tools (Mongo Express) installation script

## Before Installation

- Ensure **`secrets.json`** is configured as described [here](https://github.com/dkfz-unite/unite-environment#secrets)
- Ensure docker network '**unite**' is created

## Installation

Open this sfolder in terminal and run required command:
- To install Mongodb server
  ```bash
  sh deploy.sh
  ```
- To install Mongodb management tools (optional)
  ```bash
  sh deploy.mgmt.sh
  ```

## Services

|Service|Container|Alias|Container Port|Host Port|
|:------|:--------|:----|:---|:---------|
|Mongodb|mongo|mongo.unite.net|2701|2701|
|Express|mongo.mgmt|mgmt.mongo.unite.net|8081|8082|

All components are running in docker network '**unite**'.
