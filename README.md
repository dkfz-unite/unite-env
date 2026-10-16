## UNITE Environment

Shared architecture, development workflows, and agent instructions:
[UNITE project documentation](https://github.com/dkfz-unite/.github/blob/main/README.md).

UNITE platform installation scripts and configuration files

The same installation process is used locally and on servers. All script
examples use `sh`; executable permissions are not required. Run each script
from its containing directory because paths inside it are relative.

### Prerequisites
- Software
  - Docker
  - Docker compose
- Command line tools
  - git
  - jq (https://stedolan.github.io/jq) - only for `programs/elasticsearch/check.mem.sh`
  - openssl
  - wget
  
### Folder Structure
- `applications`
  - `unite` - web portal
    - _docker-compose.yml_ - installation configuration
    - _docker-compose.build.yml_ - build override (from repository source code), merged with _docker-compose.yml_
    - _deploy.sh_ - installation script
    - _build.local.sh_ - local installation script (from repository source code - configurable local source)
    - _build.remote.sh_ - remote installation script (from repository source code - remote source)
  - `unite-identity` - identity web API
  - `unite-composer` - composer web API
  - `unite-analysis` - analysis web API
  - `unite-analysis-deg` - differential gene expression analysis (DEG) web API
  - `unite-analysis-scell` - scRNA dataset creation analysis (SCell) web API
  - `unite-analysis-surv` - survival curve estimation analysis (Surv) web API
  - `unite-analysis-dm` - differential methylation analysis (DM) web API
  - `unite-analysis-pcam` - methylation principal component analysis (PCA) web API
  - `unite-analysis-dep` - differential protein expression analysis web API
  - `unite-analysis-umapp` - protein expression UMAP analysis web API
  - `unite-analysis-cedp` - additional CEDP analysis runner configuration
  - `unite-feed-donors` - donors data feed web API
  - `unite-feed-images` - imaging data feed web API
  - `unite-feed-specimens` - specimens data feed web API
  - `unite-feed-omics` - omics data feed web API
  - `unite-data-migrations` - domain data migrations service
  - `unite-identity-data-migrations` - identity data migration service
  - `unite-ensembl-data` - ensembl data Web API
  - `unite-ensembl-vep` - ensembl Variant Effect Predictor (VEP) web API
- `programs`
  - `postgresql` - data storage
    - _docker-compose.yml_ - installation configuration
    - _docker-compose.**mgmt**.yml_ - management tools installation configuration
    - _deploy.sh_ - installation script
    - _deploy.**mgmt**.sh_ - management tools installation script
  - `elasticsearch` - search engine and indices storage
  - `mongodb` - cache and technical data storage
  - `mysql` - Ensembl data storage
- `scripts`
  - _configure.sh_ - general environment configuration sub-script (used by dedicated environemnt scripts)
  - _configure.**linux**.sh_ - **Linux** environment configuration script
  - _configure.**macos**.sh_ - **MacOS** environment configuration script
  - _generate-ssl.sh_ - SSL certificate generation script
  - _deploy.sh_ - installation script
  - _build.sh_ - build and install script
  - _uninstall.**hard**.sh_ - **hard** uninstallation script (**removes** data and volumes)
  - _uninstall.**soft**.sh_ - **soft** uninstallation script (**keeps** data and volumes)
  - _deploy.mgmt.sh_ - install management tools
  - _deploy.apps.sh_ - install applications script (for easy updates)
  - _build.apps.sh_ - build and install applications script (for easy updates)
  - _ensembl.sh_ - Ensembl release and genome build used by the Ensembl data and VEP cache scripts
  - `app` - shared _deploy.sh_, _build.remote.sh_ and _build.local.sh_ called by every application
- _.env.services_ - source locations of the services (local path, repository URL, default branch)
- _.env_ - shared runtime configuration (instance settings, service hosts and ports)
- _.env.secrets.template_ - template of _.env.secrets_ with all required credentials

### Configuration and secrets
All deployment scripts pass two environment files to Docker Compose:
`--env-file ../../.env --env-file ../../.env.secrets`. Each `docker-compose.yml`
maps the variables it needs explicitly, e.g. `UNITE_SQL_HOST: ${UNITE_PGSQL_HOST}`.
Scripts that need a value themselves (e.g. the GitHub token for `git clone`)
load it into the script's own shell with `. ../../.env.secrets` (not exported).

- **.env** (in the repository): instance settings, including the genome build
  `UNITE_GENOME_BUILD`, and the hosts and ports of the environment services
  (`UNITE_PGSQL_*`, `UNITE_MYSQL_*`, `UNITE_MONGO_*`, `UNITE_ELASTIC_HOST`).
- **.env.secrets** (never committed, listed in `.gitignore`): created from
  `.env.secrets.template`:
  - `UNITE_API_KEY` - shared 32-character key used to sign and validate user/service JWTs
  - `UNITE_ADMIN_USER`, `UNITE_ADMIN_PASSWORD` - root user for portal administration
  - `UNITE_GITHUB_USER`, `UNITE_GITHUB_TOKEN` - user name and personal access token with **repository** and **packages** permissions for source code and packages on **GitHub** (see GitHub [instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token))
  - `UNITE_PGSQL_USER`, `UNITE_PGSQL_PASSWORD` - PostgreSQL credentials
  - `UNITE_MYSQL_USER`, `UNITE_MYSQL_PASSWORD` - MySQL credentials (Ensembl data); the user is always `root`, the MySQL image only sets the root password
  - `UNITE_MONGO_USER`, `UNITE_MONGO_PASSWORD` - MongoDB credentials
  - `UNITE_ELASTIC_USER`, `UNITE_ELASTIC_PASSWORD` - Elasticsearch credentials; the user is always `elastic` (built-in superuser). Kibana connects as the built-in `kibana_system` user with the same password, which `programs/elasticsearch/deploy.mgmt.sh` sets.

To generate passwords one of command line tools can be used:
- `openssl rand -base64 22` - to generate a 32-character Base64 string

> [!WARNING]
> ALWAYS CHANGE ALL CREDENTIALS FOR PRODUCTION USE!

> [!WARNING]
> NEVER COMMIT `.env.secrets` TO THE REPOSITORY!

> [!NOTE]
> For development it is best to keep most of the default credentials.

### Installation
Choose, which Genome reference to use for the portal DNA and Bulk RNA annotation pipelines `GRCh37` or `GRCh38`.  
Genome reference version is choosen once per installation and can not be changed later. If you need to support both, consider having two separate servers.  
Using of both genome references on one server is not possible.

Note, that genome reference version defines only which databases and pipelines will be used for DNA and Bulk RNA sequencing data annotation.  
Set the chosen version in `UNITE_GENOME_BUILD` in `.env` (`GRCh37` by default). The services and the Ensembl data and VEP cache scripts read it from there.  
For other data types (e.g. single cell RNA or methylation array data) any reference genome can be used, no matter which version is configured for DNA and bulk RNA pipelines.

1. Clone this **unite-env** repository
1. Copy `.env.secrets.template` to `.env.secrets` and **change all credentials**
1. Review the instance settings in `.env`, including the genome build `UNITE_GENOME_BUILD` (`GRCh37` or `GRCh38`)
1. For local source builds, set `UNITE_SOURCE_PATH_PREFIX` once in your shell
   profile (`~/.zshrc` or `~/.bashrc`) to the folder that contains the source
   repositories: `export UNITE_SOURCE_PATH_PREFIX=~/Work/unite/projects`
1. Open `unite-env/scripts` folder in terminal
1. Configure environment
   - For **Linux** environment: `sh configure.linux.sh`
   - For **MacOS** environments: `sh configure.macos.sh`
1. Install SSL certificate
   - If valid certificate is available
     - Copy certificate and it's key to `unite-env/ssl` directory (create directory if missing)
     - Name certificate and it's key `unite-cert.pem` and `unite-key.pem` 
     - Change certificate and it's key permissions to `600` using `chmod` command
   - If valid certificate is not available, generate self signed development certificate
     - For **localhost**: `sh generate-ssl.sh`
     - For **network**: `sh generate-ssl.sh <IP address or domain name>`
1. Install programs and applications
   - `sh deploy.sh`
1. Install management tools (optional)
   - `sh deploy.mgmt.sh`
1. Install Ensembl Data service
   - Open `unite-env/programs/mysql` folder in terminal
   - Download cache `sh download-cache.sh` (This may take some time, if download process breaks, run the script again to continue)
   - Extract cache `sh extract-cache.sh`
   - Restore database from cache `sh install-cache.sh` (This may take several minutes)
1. Install Ensembl VEP service
   - Open `unite-env/applications/unite-ensembl-vep` folder in terminal
   - Download cache `sh download-cache.sh` (This may take several hours, if download process breaks, run the script again to continue)
   - Extract cache `sh extract-cache.sh`

For custom installation run installation scripts for dedicated programs or applications.  
Cache downloaded and extracted for **Ensembl Data** and **Ensembl VEP** services **will persist** on the disk unless you remove it manually, so no need to run download and extraction scripts again for recurrent installation of the platform.

The scripts download Ensembl release 116 for the configured genome build: the Ensembl core database from `ftp.ensembl.org/pub/[grch37/]release-116/mysql` and the indexed VEP cache from `.../release-116/variation/indexed_vep_cache`. Release 116 is the last release published on `ftp.ensembl.org`; newer Ensembl data is published on the new Ensembl platform in another format. The VEP cache release has to match the release of the VEP image used by **unite-ensembl-vep**.

### Updating and building individual services

For the owner's usual full deployment/update, open `scripts/` and run
`sh deploy.sh`. It deploys programs, migration applications, platform services,
Ensembl wrappers, and configured scientific runners. `sh deploy.apps.sh` updates
a smaller explicit list of migrations and main platform services; it does not
include all runners or Ensembl wrappers.

For one application, open `applications/<service>/` and choose:

| Command | Behavior |
| --- | --- |
| `sh deploy.sh` | Pull the published GHCR image and start/update the service |
| `sh build.remote.sh` | Clone the repository (default branch from `.env.services`, else the repository default), then build and run it |
| `sh build.remote.sh dev` | Clone and build the given branch |
| `sh build.local.sh` | Copy the local source folder, then build and run it |

Each of these is a one-line call of the shared script in `scripts/app/` with the
service key, e.g. `sh ../../scripts/app/build.remote.sh composer "$1"`. The
shared scripts read the service's settings from `.env.services`:

```sh
UNITE_COMPOSER_NAME="UNITE Composer service"                        # display name
UNITE_COMPOSER_PATH=${UNITE_SOURCE_PATH_PREFIX}/unite-composer       # local source
UNITE_COMPOSER_URL=${UNITE_SOURCE_URL_PREFIX}/unite-composer.git     # repository
UNITE_COMPOSER_BRANCH=                                              # empty = repository default
```

To build a single service from another folder, a fork or a branch on your
machine, override its values in `.env.services.local` (gitignored, read after
`.env.services`). The GitHub token from `.env.secrets` is sent only to
`github.com`, as an HTTP header, and is not stored in the cloned repository.
`UNITE_PROJECT` sets the Compose project (default `unite`; plugins use
`unite-plugins`). Applications share the project `unite`, the programs
`unite-env`, each with its own compose file, so the scripts set
`COMPOSE_IGNORE_ORPHANS=true`: Compose would otherwise report the other
services of the project as orphans. Never run `--remove-orphans`; it would remove
them.

For local changes to a service's Compose configuration without editing
committed files, create `docker-compose.override.yml` in its folder (gitignored).
The shared scripts add it as the last `-f` when it exists, after
`docker-compose.build.yml` for builds. It only needs the service name and what
changes, e.g.:

```yaml
services:
  composer.unite.net:
    environment:
      ASPNETCORE_ENVIRONMENT: Development
```

Single values and `environment` entries are replaced, `ports` are added,
`volumes` are merged by their target path; `!override` replaces a whole list. Top-level `build.sh` and `build.apps.sh` do not forward a
branch argument. Local/remote build scripts replace their installation-side
`src/` directory; local builds copy working-tree contents, including uncommitted
changes. Edited sibling libraries are not automatically substituted for NuGet
package dependencies.

For local library development, the owner temporarily enables sibling
`ProjectReference` entries in service project files, often already commented
out there. For Docker verification, the owner publishes new NuGet packages by
pushing the library to `main`, then selects the new version in consuming
services. Versions: patch for each package published during development, minor
when the change is released, major for breaking changes.

Published application images use `ghcr.io/dkfz-unite/<repository>:latest` with
`pull_policy: always`. The owner confirmed publication after pushes to `main`;
the selected branch-build workflow is separate from published-image deployment.

### Configuration status

Most runtime configuration is in each component's `docker-compose.yml`.
Scripts pass `.env` and `.env.secrets` to Compose (`--env-file`), and each
compose file maps the variables it uses.
Build Compose files contain only the build settings (`build`, local `image`
name) and are merged with the base file on the command line:
`docker compose -f docker-compose.yml -f docker-compose.build.yml up -d --build`.

Moving secrets to Docker secrets is planned.

### Uninstallation
To uninstall UNITE platform, run corresponding command from unite-env/scripts folder:
- To **remove** all services **with all their data**: `sh uninstall.hard.sh`
- To **remove** only services, **but keep all their data**: `sh uninstall.soft.sh`

!Note that uninstallation scripts will remove all containers/images from host machine. If you have other applications runing in docker, clear unite containers and images manually.

### Services
Application is running in docker and has the following components:

|Service|Container|Alias|Container Port|Host Port|
|:------|:--------|:----|:---|:---------|
|Elasticsearch|es|es.unite.net|9200|9200|
|Mongodb|mongo|mongo.unite.net|27017|27017|
|Postgresql|pgsql|pgsql.unite.net|5432|5432|
|Mysql|mysql|mysql.unite.net|3306|3306|
|Web Portal|unite.portal|portal.unite.net|80;443|80;443|
|Identity Service|unite.identity|identity.unite.net|80|5000|
|Composer Service|unite.composer|composer.unite.net|80|5002|
|Analysis Service|unite.analysis|analysis.unite.net|80|5004|
|Analysis Service (DEG)|unite.analysis.deg|deg.analysis.unite.net|80|5300|
|Analysis Service (SCell)|unite.analysis.scell|scell.analysis.unite.net|80|5302|
|Analysis Service (Surv)|unite.analysis.surv|surv.analysis.unite.net|80|5304|
|Analysis Service (DM)|unite.analysis.dm|dm.analysis.unite.net|80|5306|
|Analysis Service (PCA)|unite.analysis.pcam|pcam.analysis.unite.net|80|5308|
|Analysis Service (DEP)|unite.analysis.dep|dep.analysis.unite.net|80|5310|
|Analysis Service (UMAPP)|unite.analysis.umapp|umapp.analysis.unite.net|80|5312|
|Analysis Service (CEDP)|unite.analysis.cedp|cedp.analysis.unite.net|80|5314|
|Cell-x-Gene image/container configuration|unite.analysis.cxg|cxg.viewer.unite.net|80|54300|
|Donors Feed Service|unite.feed.donors|donors.feed.unite.net|80|5100|
|Images Feed Service|unite.feed.images|images.feed.unite.net|80|5102|
|Specimens Feed Service|unite.feed.specimens|specimens.feed.unite.net|80|5104|
|Omics Feed Service|unite.feed.omics|omics.feed.unite.net|80|5106|
|Ensembl Data Service|unite.ensembl.data|data.ensembl.unite.net|80|5200|
|Ensembl VEP Service|unite.ensembl.vep|vep.ensembl.unite.net|80|5202|

> [!NOTE]
> Core database and API ports in the table bind to host loopback (*127.0.0.1*);
> the portal publishes 80/443 on all host interfaces. Optional management Compose
> files publish Adminer, Mongo Express, and Kibana on 8081/8082/8083 without a
> loopback bind. The owner's server setup permits external web access on 80/443
> and is managed over SSH; databases are not directly reachable from a developer's
> computer. External reachability also depends on the server's network rules.
