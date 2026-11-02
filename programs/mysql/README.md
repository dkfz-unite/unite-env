# MySQL service

MySQL 5.6 stores the Ensembl reference databases used by Ensembl Data.
This folder manages the database server. Reference database downloads,
extraction, import and SQL adjustments are maintained with the
[Ensembl Data service](../../applications/unite-ensembl-data/README.md).

## Files

- `docker-compose.yml` - MySQL server and persistent data volume.
- `deploy.sh` - install or update the MySQL container.
- `connect.sh` - open a MySQL command-line session.

## Installation

Configure `.env.secrets` and create the `unite` Docker network as described in
the [installation instructions](../../README.md#installation).

From this folder, run:

```sh
sh deploy.sh
```

Database files persist in the named `mysql.data` volume. Ensembl Data imports
reference data through a temporary client container on the `unite` network.
The client mounts the application's cache read-only; MySQL needs no cache mount.

For installations with an old `programs/mysql/cache` directory, follow the
[cache relocation instructions](../../applications/unite-ensembl-data/README.md#existing-installations)
when reusing downloaded reference files. Existing databases need no reimport.

## Access

| Service | Container | Alias | Container port | Host port |
| --- | --- | --- | --- | --- |
| MySQL | mysql | mysql.unite.net | 3306 | 3306 |

The container uses the `unite` Docker network. Its database port is published
on the Docker host's `127.0.0.1`.
