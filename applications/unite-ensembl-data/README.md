# Ensembl Data service

Ensembl Data provides access to reference genes, transcripts and proteins
stored in the [MySQL server](../../programs/mysql/README.md).

## Files

- `deploy.sh`, `build.remote.sh`, `build.local.sh` - deploy or build the API service.
- `docker-compose.yml`, `docker-compose.build.yml` - API service configuration.
- `download-cache.sh` - download the Ensembl core schema and selected table data.
- `extract-cache.sh` - extract downloaded files.
- `install-cache.sh` - import the schema and table data, then apply SQL adjustments.
- `migrations/` - SQL adjustments applied during the reference database import.
- `cache/` - downloaded and extracted reference files, excluded from Git.

## Reference database setup

Start MySQL from `programs/mysql` with `sh deploy.sh` before importing data.
The scripts use the MySQL credentials in `.env.secrets` and the host/port from
`.env`, overridden by `.env.local` when present.

From this folder, run:

```sh
sh download-cache.sh
sh extract-cache.sh
sh install-cache.sh
```

The scripts use Ensembl release 116 and `UNITE_GENOME_BUILD` from
[.env](../../.env), overridden by `.env.local` when present, through
[scripts/ensembl.sh](../../scripts/ensembl.sh).

For `GRCh37`, files are stored in `cache/core37` and imported into
`homo_sapiens_core_116_37`; for `GRCh38`, they use `cache/core38` and
`homo_sapiens_core_116_38`. Both builds have the same core schema and tables.
`install-cache.sh` runs the `mysql` and `mysqlimport` clients in a temporary
`mysql:5.6` container on the `unite` network. That container mounts this folder's
`cache/` at `/cache` and `migrations/` at `/migrations`, both read-only. It connects
to the running MySQL server and is removed when the import command finishes.
The MySQL server keeps only its persistent `mysql.data` volume; the API
accesses the imported databases through MySQL.

The import stops if a command fails. An existing database is not overwritten:
the database creation step fails if the selected database already exists.

Downloads can be resumed by running `sh download-cache.sh` again. Downloaded
and extracted files persist across service deployments.

## Existing installations

Installed databases remain in the named `mysql.data` volume. This directory
change does not require another database import or download.

If downloaded files are still in `programs/mysql/cache` and the new cache
directory does not exist, run from the installation root:

```sh
mv programs/mysql/cache applications/unite-ensembl-data/cache
```

If both cache directories already exist, combine their contents in the new
location, retaining existing downloaded files. No MySQL restart is needed to
run the temporary import client. A later `sh deploy.sh` from `programs/mysql`
removes the old server-side cache mount while retaining its installed databases.

## API deployment

From this folder, run `sh deploy.sh`, or use `sh build.remote.sh` /
`sh build.local.sh` as described in the
[deployment instructions](../../README.md#updating-and-building-individual-services).
