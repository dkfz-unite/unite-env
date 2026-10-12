# Mysql Service

MySQL 5.6 serves the following purpose:
- Ensembl data storage - stores required Ensembl data

## Files

Folder contains the following files:
- `docker-compose.yml` - Mysql server configuration file
- `deploy.sh` - Mysql server installation script
- `download-cache-grch37.sh` / `download-cache-grch38.sh` - download the matching Ensembl schema and selected table data
- `extract-cache-grch37.sh` / `extract-cache-grch38.sh` - extract downloaded files
- `install-cache-grch37.sh` / `install-cache-grch38.sh` - import schema and data

## Before Installation

- Ensure **`secrets.json`** is configured as described [here](../../README.md#secrets)
- Ensure docker network '**unite**' is created

## Installation

Open this folder in terminal and run the required commands through `sh`.
The examples below use GRCh37; use the `grch38` counterparts for GRCh38.
- To install Mysql server
  ```bash
  sh deploy.sh
  ```
- Download Ensembl database schema and cache files
  ```bash
  sh download-cache-grch37.sh
  ```
- Extract Ensembl database schema and cache files
  ```bash
  sh extract-cache-grch37.sh
  ```
- Install Ensembl database schema and cache files (might take several minutes)
  ```bash
  sh install-cache-grch37.sh
  ```

## Services

|Service|Container|Alias|Container Port|Host Port|
|:------|:--------|:----|:---|:---------|
|Mysql|mysql|mysql.unite.net|3306|3306|

All components are running in docker network '**unite**'.
The database port is published on the Docker host's `127.0.0.1`.
