# Postgresql Service

Postgresql service serves the follwing purposes:
- Data storage - stores all uploaded data
- Identity storage - stores user accounts data

## Files

Folder contains the following files:
- `docker-compose.yml` - Postgresql server configuration file
- `docker-compose.mgmt.yml` - Postgresql management tools (Adminer) configuration file
- `install.sh` - Postgresql server installation script
- `install.mgmt.sh` - Postgresql management tools (Adminer) installation script
- `connect.sh` - Postgresql CLI connection script

## Before Installation

- Ensure **`secrets.json`** is configured as described [here](https://github.com/dkfz-unite/unite-environment#secrets)
- Ensure docker network '**unite**' is created

## Installation

Open this sfolder in terminal and run required command:
- To install Postgresql server
  ```bash
  sh install.sh
  ```
- To install Postgresql management tools (optional)
  ```bash
  sh install.mgmt.sh
  ```

## Services

|Service|Container|Alias|Container Port|Host Port|
|:------|:--------|:----|:---|:---------|
|Postgresql|sq|sql.unite.net|5432|5432|
|Adminer|sql.mgmt|mgmt.sql.unite.net|8080|8081|

All components are running in docker network '**unite**'.
