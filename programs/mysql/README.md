# Mysql Service

Mysql service serves the follwing purposes:
- Ensembl data storage - stores required Ensembl data

## Files

Folder contains the following files:
- `docker-compose.yml` - Mysql server configuration file
- `deploy.sh` - Mysql server installation script
- `download-ensembl-cache.sh` - Ensembl database schema and data downloading script
- `extract-ensembl-cache.sh` - Ensembl database schema and data extraction script
- `install-ensembl-cache.sh` - Ensembl database schema and data installation script

## Before Installation

- Ensure **`secrets.json`** is configured as described [here](https://github.com/dkfz-unite/unite-environment#secrets)
- Ensure docker network '**unite**' is created

## Installation

Open this sfolder in terminal and run required command:
- To install Mysql server
  ```bash
  sh deploy.sh
  ```
- Download Ensembl database schema and cache files
  ```bash
  sh download-ensembl-cache.sh
  ```
- Extract Ensembl database schema and cache files
  ```bash
  sh extract-ensembl-cache.sh
  ```
- Install Ensembl database schema and cache files (might take several minutes)
  ```bash
  sh install-ensembl-cache.sh
  ```

## Services

|Service|Container|Alias|Container Port|Host Port|
|:------|:--------|:----|:---|:---------|
|Mysql|mysql|mysql.unite.net|3306|3306|

All components are running in docker network '**unite**'.
