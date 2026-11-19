# Ensembl Data service

Ensembl Data provides access to reference genes, transcripts and proteins
stored in the [MySQL server](../../programs/mysql/README.md).

## Files

- `deploy.sh`, `build.remote.sh`, `build.local.sh` - deploy or build the API service.
- `docker-compose.yml`, `docker-compose.build.yml` - API service configuration.
- `download-cache.sh` - download both core schemas, selected table data and liftover chains.
- `extract-cache.sh` - extract downloaded files.
- `install-cache.sh` - create both databases, import table data and apply annotation SQL adjustments.
- `cache.sh` - shared table selection for the three setup scripts.
- `tables.txt` - editable table list used for both genome builds.
- `import-cache.sh` - import steps executed inside the temporary MySQL client container.
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

The scripts prepare Ensembl release 116 for **both GRCh37 and GRCh38**,
independently of `UNITE_GENOME_BUILD`. Both receive the same selected annotation
and reference-sequence tables. `UNITE_GENOME_BUILD` still selects the instance's
integration and VEP annotation build; installing both reference databases does
not change it.

`tables.txt` lists all 77 tables in the release 116 core schemas, one name per
line. Enabled tables have no prefix; unused tables are commented with `#`.
Uncomment a table to include it, or comment it to exclude it. Download,
extraction and import all use this list. The upstream core schema is always
included automatically. After enabling additional tables, rerun all three
setup scripts without arguments.

The sequence tables are `assembly`, `assembly_exception`, `coord_system`,
`dna` and `seq_region`. Assembly tables relate chromosome coordinates to the
component regions containing DNA, including their orientation and exceptions.
Their relationships are described in the
[Ensembl core schema](https://github.com/Ensembl/ensembl/blob/release/116/sql/table.sql).

GRCh37 files are stored in `cache/core37` and imported into
`homo_sapiens_core_116_37`; GRCh38 uses `cache/core38` and
`homo_sapiens_core_116_38`. Both databases use the complete upstream schema;
only table data enabled in `tables.txt` is imported. A second VEP cache is not
installed. The GRCh37↔GRCh38 UCSC chain files are stored in `cache/chains` and
mounted read-only into the Ensembl Data service.

`install-cache.sh` runs the `mysql` and `mysqlimport` clients in a temporary
`mysql:5.6` container on the `unite` network. That container mounts this application
folder read-only at `/setup`, including the scripts, `cache/` and `migrations/`. It connects
to the running MySQL server and is removed when the import command finishes.
The MySQL server keeps only its persistent `mysql.data` volume; the API
accesses the imported databases through MySQL.

Missing databases are created from the upstream schema. Existing schemas are
not restored, and populated tables are reused without loading their files
again. Empty selected tables are imported. This also avoids duplicate rows in
tables without unique keys. The annotation adjustment (`migrations/00001.sql`)
is applied to each build if its index is not already present.

The import stops if a command fails. A populated table is assumed to have been
installed successfully; row counts are not compared with the downloaded file.
If a load was interrupted or failed after writing rows, inspect that table
before retrying: partial contents are also treated as populated. This setup
adds missing tables; it does not repair partial imports or refresh existing rows.

Downloads can be resumed by running `sh download-cache.sh` again. Already
extracted files are reused, and extraction can also be rerun. Only explicitly
selected files are extracted and imported; unrelated files in the cache are
not included. Downloaded and extracted files persist across service deployments.

## Existing installations

Run the same three commands, with **no arguments**, to extend an existing
installation:

```sh
sh download-cache.sh
sh extract-cache.sh
sh install-cache.sh
```

Already extracted files are reused. Installed annotation and DNA tables are
preserved. An installation with annotations for GRCh37 and sequence data for
GRCh38 will gain the missing GRCh38 annotation tables. The previous `sequence`
argument and separate table lists are no longer used.

Import while reference-data consumers are idle, since table loading is not an
atomic operation across both databases. Existing databases must match the
release and build in their names.

Installed databases remain in the named `mysql.data` volume. The earlier move
of setup scripts out of `programs/mysql` does not itself require another import.

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
