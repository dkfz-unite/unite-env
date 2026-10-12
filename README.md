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
  - jq (https://stedolan.github.io/jq)
  - openssl
  - wget
  
### Folder Structure
- `applications`
  - `unite` - web portal
    - _docker-compose.yml_ - installation configuration
    - _docker-compose.build.yml_ - build and installation configuration (from repository source code)
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
- _secrets_template.json_ - JSON configuration template file with all required credentials
- _config_template.json_ - local source-workspace path template for local builds
- _.env_ - initial shared runtime configuration currently used by Identity

### Secrets
Deployment scripts read shared credentials from **secrets.json**. Its template
is stored in the `unite-env` repository. The file has the following structure:
```json
{
    "api": {
        "key": "Defautl32BitApiKeyHasToBeChanged"
    },
    "admin": {
        "user": "admin@unite.net",
        "password": "Long-pa55w0rd"
    },
    "github":{
        "user": "root",
        "token": "Long-t0ken"
    },
    "sql": {
        "user": "root",
        "password": "Long-pa55w0rd"
    },
    "mongodb": {
        "user": "root",
        "password": "Long-pa55w0rd"
    },
    "elasticsearch": {
        "user": "elastic",
        "password": "Long-pa55w0rd"
    }
}
```
Each section represents credentials for specific part of the platform services:
- _api_ - shared 32-character key used to sign and validate user/service JWTs
- _admin_ - root **user** and **password** for portal administration
- _github_ - **user** name and personal access **token** with full **repository** and **packages** permissions for accessing source code and packages from **Github** (follow github [instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) to generate it)
- _sql_ - **user** name and **password** for **SQL** server
- _mongodb_ - **user** name and **password** for **MongoDb** server
- _elasticsearch_ - **user** name and **password** for **Elasticsearch** server

To generate passwords one of command line tools can be used:
- `openssl rand -base64 22` - to generate a 32-character Base64 string

> [!WARNING]
> ALWAYS CHANGE ALL CREDENTIALS FOR PRODUCTION USE!

> [!WARNING]
> NEVER COMMIT THIS FILE TO THE REPOSITORY!

> [!NOTE]
> For development it is best to keep most of the default credentials.

### Installation
Choose, which Genome reference to use for the portal DNA and Bulk RNA annotation pipelines `GRCh37` or `GRCH38`.  
Genome reference version is choosen once per installation and can not be changed later. If you need to support both, consider having two separate servers.  
Using of both genome references on one server is not possible.

Note, that genome reference version defines only which databases and pipelines will be used for DNA and Bulk RNA sequencing data annotation.  
If your DNA and Bulk RNA data is in GRCh37, then choose it for the installation, this version is also default and requires no additional configuration.  
If your DNA and Bulk RNA data is in GRCh38, then choose it for the installation, needs to be additionally configured as it's not default.  
For other data types (e.g. single cell RNA or methylation array data) any reference genome can be used, no matter which version is configured for DNA and bulk RNA pipelines.

1. Clone this **unite-env** repository
1. **Change credentials** in secrets_template.json and **rename** the file to **secrets.json**
1. Review the root `.env` settings used by Identity. This is an initial migration;
   credentials still come from `secrets.json` through the deployment scripts.
1. For local source builds, copy `config_template.json` to `config.json` and set
   `SourceCodeDirectoryPath` to the parent directory containing the source repos
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
1. Change reference genome version (**only if you've choosen to use GRCh38**, skip this step if your choice is GRCh37)
   - Open `unite-env/applications/unite-feed-omics/docker-compose.yml` file
   - Change line `UNITE_GENOME_BUILD: GRCh37` to `UNITE_GENOME_BUILD: GRCh38`
1. Install programs and applications
   - `sh deploy.sh`
1. Install management tools (optional)
   - `sh deploy.mgmt.sh`
1. Install Ensembl Data service
   - Open `unite-env/programs/mysql` folder in terminal
   - Download cache `sh download-cache-grch[37|38].sh` (This may take some time, if download process breaks, run the script again to continue)
   - Extract cache `sh extract-cache-grch[37|38].sh`
   - Restore database from cache `sh install-cache-grch[37|38].sh` (This may take several minutes)
1. Install Ensembl VEP service
   - Open `unite-env/applications/unite-ensembl-vep` folder in terminal
   - Download cache `sh download-cache-grch[37|38].sh` (This may take several hours, if download process breaks, run the script again to continue)
   - Extract cache `sh extract-cache-grch[37|38].sh`

For custom installation run installation scripts for dedicated programs or applications.  
Cache downloaded and extracted for **Ensembl Data** and **Ensembl VEP** services **will persist** on the disk unless you remove it manually, so no need to run download and extraction scripts again for recurrent installation of the platform.

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
| `sh build.remote.sh` | Clone remote source, normally `main`, then build and run locally |
| `sh build.remote.sh dev` | Build and run the selected branch where the script accepts a branch argument |
| `sh build.local.sh` | Copy local source from `SourceCodeDirectoryPath`, then build and run it |

The script is named **build.remote.sh**. Most application remote-build scripts
accept a branch argument; identity-data-migrations currently clones without
processing one. Top-level `build.sh` and `build.apps.sh` do not currently forward
a branch argument. Local/remote build scripts replace their installation-side
`src/` directory; local builds copy working-tree contents, including uncommitted
changes. Edited sibling libraries are not automatically substituted for NuGet
package dependencies.

For local library development, the owner temporarily enables sibling
`ProjectReference` entries in service project files, often already commented
out there. For Docker verification, the owner publishes new NuGet packages by
pushing the library to `main`, then selects the new version in consuming
services. The stated version workflow is a minor increase for testing, then
a major increase after successful verification.

Published application images use `ghcr.io/dkfz-unite/<repository>:latest` with
`pull_policy: always`. The owner confirmed publication after pushes to `main`;
the selected branch-build workflow is separate from published-image deployment.

### Configuration status

Most runtime configuration is in each component's `docker-compose.yml`.
Scripts pass credentials as environment variables for Compose interpolation.
Build Compose files currently inherit services using `extends`.

Identity already uses `--env-file ../../.env`; consolidation of common variables
for the remaining services and simplification of Compose file composition are
planned. This documentation does not change those scripts or configuration.

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
