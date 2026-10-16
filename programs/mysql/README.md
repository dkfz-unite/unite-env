# Mysql Service

MySQL 5.6 serves the following purpose:
- Ensembl data storage - stores required Ensembl data

## Files

Folder contains the following files:
- `docker-compose.yml` - Mysql server configuration file
- `deploy.sh` - Mysql server installation script
- `download-cache.sh` - download the Ensembl core database schema and selected table data
- `extract-cache.sh` - extract downloaded files
- `install-cache.sh` - import schema and data

The cache scripts use Ensembl release 116 and the genome build set in `UNITE_GENOME_BUILD` in [.env](../../.env) (`GRCh37` or `GRCh38`), see [ensembl.sh](../../scripts/ensembl.sh).
Both builds have the same database schema and tables, files are downloaded to `cache/core37` or `cache/core38` and imported into `homo_sapiens_core_116_37` or `homo_sapiens_core_116_38`.

## Before Installation

- Ensure **`secrets.json`** is configured as described [here](../../README.md#secrets)
- Ensure docker network '**unite**' is created

## Installation

Open this folder in terminal and run the required commands through `sh`.
- To install Mysql server
  ```bash
  sh deploy.sh
  ```
- Download Ensembl database schema and cache files
  ```bash
  sh download-cache.sh
  ```
- Extract Ensembl database schema and cache files
  ```bash
  sh extract-cache.sh
  ```
- Install Ensembl database schema and cache files (might take several minutes)
  ```bash
  sh install-cache.sh
  ```

## Services

|Service|Container|Alias|Container Port|Host Port|
|:------|:--------|:----|:---|:---------|
|Mysql|mysql|mysql.unite.net|3306|3306|

All components are running in docker network '**unite**'.
The database port is published on the Docker host's `127.0.0.1`.
