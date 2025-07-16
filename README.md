## UNITE Environment

UNITE platform installation scripts and configuration files

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
  - `unite-analysis-de` - RNA differential expression (DE) analysis web API
  - `unite-analysis-scell` - scRNA dataset creation (SCell) analysis web API
  - `unite-analysis-surv` - survival curve estimation (Surv) analysis web API
  - `unite-analysis-dm` - differential methylation (DM) analysis web API
  - `unite-feed-donors` - donors data feed web API
  - `unite-feed-images` - imaging data feed web API
  - `unite-feed-specimens` - specimens data feed web API
  - `unite-feed-omics` - omics data feed web API
  - `unite-data-migrations` - domain data migrations service
  - `unite-identity-data-migrations` - identity data migration service
  - `unite-ensembl-data` - ensembl data Web API
  - `unite-ensembl-vep` - ensembl Varian Effect Predictor (VEP) web API
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

### Secrets
All sensitive information is stored in **secrets.json** file. Template of this file is stored in unite-environment repository on github. File has the following structure:
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
- _api_ - **API** key, used for user and service authentication
- _admin_ - root **user** and **password** for portal administration
- _github_ - **user** name and personal access **token** with full **repository** and **packages** permissions for accessing source code and packages from **Github** (follow github [instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) to generate it)
- _sql_ - **user** name and **password** for **SQL** server
- _mongodb_ - **user** name and **password** for **MongoDb** server
- _elasticsearch_ - **user** name and **password** for **Elasticsearch** server

To generate passwords one of command line tools can be used:
- `openssl rand -base64 22` - to generate 32 bit Base64 string

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

1. Download **unite-environment** source files from git this repository
1. **Change credentials** in secrets_template.json and **rename** the file to **secrets.json**
1. Open `unite-env/scripts` folder in terminal
1. Configure environment
   - For **Linux** environment: `sh configure.linux.sh`
   - For **MacOS** environments: `sh configure.macos.sh`
1. Install SSL certificate
   - If valid certificate is available
     - Copy certificate and it's key to `unite-environment/ssl` directory (create directory if missing)
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

### Uninstallation
To uninstall UNITE platform, run corresponding command from unite-environment/scripts folder:
- To **remove** all services **with all their data**: `sh uninstall.hard.sh`
- To **remove** only services, **but keep all their data**: `sh uninstall.soft.sh`

!Note that uninstallation scripts will remove all containers/images from host machine. If you have other applications runing in docker, clear unite containers and images manually.

### Services
Application is running in docker and has the following components:

|Service|Container|Alias|Container Port|Host Port|
|:------|:--------|:----|:---|:---------|
|Elasticsearch|es|es.unite.net|9200|9200|
|Mongodb|mongo|mongo.unite.net|2701|2701|
|Postgresql|pgsq|pgsql.unite.net|5432|5432|
|Mysql|mysql|mysql.unite.net|3306|3306|
|Web Portal|unite.portal|portal.unite.net|80;443|80;443|
|Identity Service|unite.identity|identity.unite.net|80|5000|
|Composer Service|unite.composer|composer.unite.net|80|5002|
|Analysis Service|unite.analysis|analysis.unite.net|80|5004|
|Analysis Service (DE)|unite.analysis.de|de.analysis.unite.net|80|5300|
|Analysis Service (SCell)|unite.analysis.scell|scell.analysis.unite.net|80|5302|
|Analysis Service (Surv)|unite.analysis.surv|surv.analysis.unite.net|80|5304|
|Analysis Service (DM)|unite.analysis.dm|dm.analysis.unite.net|80|5306|
|Donors Feed Service|unite.feed.donors|donors.feed.unite.net|80|5100|
|Images Feed Service|unite.feed.images|images.feed.unite.net|80|5102|
|Specimens Feed Service|unite.feed.specimens|specimens.feed.unite.net|80|5104|
|Omics Feed Service|unite.feed.omics|omics.feed.unite.net|80|5106|
|Ensembl Data Service|unite.ensembl.data|data.ensembl.unite.net|80|5200|
|Ensembl VEP Service|unite.ensembl.vep|vep.ensembl.unite.net|80|5202|

> [!NOTE]
> Only Web portal ports are publicly exposed (*0.0.0.0*). Ports of other components are exposed to host machine local network only (*127.0.0.1*).
