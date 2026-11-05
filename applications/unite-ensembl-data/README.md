# Ensembl Data service

Ensembl Data provides access to reference genes, transcripts and proteins
stored in the [MySQL server](../../programs/mysql/README.md).

## Files

- `deploy.sh`, `build.remote.sh`, `build.local.sh` - deploy or build the API service.
- `docker-compose.yml`, `docker-compose.build.yml` - API service configuration.
- `download-cache.sh` - download both core schemas and the selected table data.
- `extract-cache.sh` - extract downloaded files.
- `install-cache.sh` - create both databases, import table data and apply annotation SQL adjustments.
- `cache.sh` - shared table selection for the three setup scripts.
- `tables-annotation.txt` - table list for the installation's annotation build.
- `tables-sequence.txt` - table list for reference comparison and sequence-only imports.
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

The scripts use Ensembl release 116 and `UNITE_GENOME_BUILD` from
[.env](../../.env), overridden by `.env.local` when present, through
[scripts/ensembl.sh](../../scripts/ensembl.sh).

Both builds are prepared, with different table selections:

| Build | Imported data |
| --- | --- |
| Installation build (`UNITE_GENOME_BUILD`) | Existing gene, transcript and protein annotation tables, plus reference-sequence tables |
| Other build | Reference-sequence tables only |

The two `tables-*.txt` files list all tables in the Ensembl release 116 core
schemas, one table name per line. Enabled tables have no prefix; unused tables
are commented with `#`. Uncomment a table to include it, or comment it to exclude
it. Download, extraction and import all use the same selected list. The core
schema file is always included automatically.

`tables-annotation.txt` is used for the configured build during a fresh setup.
`tables-sequence.txt` is used for the other build, and for both builds when
running in `sequence` mode. Each list is complete and independent; tables are
not implicitly merged between lists. After enabling additional tables, rerun
download and extraction with the same mode you intend to import.

The sequence tables are `assembly`, `assembly_exception`, `coord_system`,
`dna` and `seq_region`. Assembly tables relate chromosome coordinates to the
component regions containing DNA, including their orientation and exceptions.
Their relationships are described in the
[Ensembl core schema](https://github.com/Ensembl/ensembl/blob/release/116/sql/table.sql).

GRCh37 files are stored in `cache/core37` and imported into
`homo_sapiens_core_116_37`; GRCh38 uses `cache/core38` and
`homo_sapiens_core_116_38`. Both databases use the complete upstream schema;
annotation tables in the secondary database remain empty. Installing sequence
data for both builds does not change the instance's annotation build or install
a second VEP cache. It prepares reference data; it does not enable liftover yet.

`install-cache.sh` runs the `mysql` and `mysqlimport` clients in a temporary
`mysql:5.6` container on the `unite` network. That container mounts this application
folder read-only at `/setup`, including the scripts, `cache/` and `migrations/`. It connects
to the running MySQL server and is removed when the import command finishes.
The MySQL server keeps only its persistent `mysql.data` volume; the API
accesses the imported databases through MySQL.

The import stops if a command fails. Fresh installation checks both database
names before creating either database and refuses to proceed if one exists.
The annotation adjustment (`migrations/00001.sql`) is applied only to the
installation build during fresh installation.

Downloads can be resumed by running `sh download-cache.sh` again. Already
extracted files are reused, and extraction can also be rerun. Only explicitly
selected files are extracted and imported; unrelated files in the cache are
not included. Downloaded and extracted files persist across service deployments.

## Existing installations

To add sequence data to an existing installation, use `sequence` with all
three scripts from this folder:

```sh
sh download-cache.sh sequence
sh extract-cache.sh sequence
sh install-cache.sh sequence
```

By default, this downloads and imports only the five sequence tables for both builds. An
existing database's schema and annotation tables are left intact. If the other
database is absent, it is created from its upstream schema first. Existing
sequence rows are preserved using `mysqlimport --ignore`: duplicate unique keys
are skipped, while missing rows are inserted. The sequence import can be rerun
after interruption, but it rereads the selected table files; it does not track
per-file import progress. It does not replace existing rows or apply annotation
adjustments.

If you extend `tables-sequence.txt`, duplicate handling follows each additional
table's keys. Tables without a primary or unique key can accumulate duplicate
rows when imported repeatedly.

Use this mode to extend an installation whose existing database and schema
were installed successfully. It does not repair an incomplete annotation
installation. Existing databases must match the release and build in their
names. Import while reference-data consumers are idle, since table loading is
not an atomic operation across both databases.

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
