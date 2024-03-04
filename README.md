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
  - `unite-analysis-deseq2` - analysis DESeq2 web API
  - `unite-donors-feed` - donors data feed web API
  - `unite-images-feed` - imaging data feed web API
  - `unite-specimens-feed` - specimens data feed web API
  - `unite-genome-feed` - genome data feed web API
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
1. Download **unite-environment** source files from git this repository
1. **Change credentials** in secrets_template.json and **rename** the file to **secrets.json**
1. Open `unite-environment/scripts` folder in terminal
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
2. Install programs and applications
   - `sh deploy.sh`
3. Install management tools (optional)
   - `sh deploy.mgmt.sh`
4. Install Ensembl Data service
   - Open `unite-environment/programs/mysql` folder in terminal
   - Download cache `sh download-ensembl-cache.sh` (This may take some time, if download process breaks, run the script again to continue)
   - Extract cache `sh extract-ensembl-cache.sh`
   - Restore database from cache `sh install-ensembl-cache.sh` (This may take several minutes)
   - Open `unite-environment/applications/unite-ensembl-data` folder in terminal
   - Run installation script `sh deploy.sh`
5. Install Ensembl VEP service
   - Open `unite-environment/applications/unite-ensembl-vep` folder in terminal
   - Download cache `sh download-cache.sh` (This may take several hours, if download process breaks, run the script again to continue)
   - Extract cache `sh extract-cache.sh`
   - Run installation script `sh deploy.sh`

For custom installation run installation scripts for dedicated programs or applications.

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
|Analysis DESeq2|unite.analysis.deseq2|deseq2.analysis.unite.net|80|5300|
|Donors Feed Service|unite.donors.feed|feed.donors.unite.net|80|5100|
|Images Feed Service|unite.images.feed|feed.images.unite.net|80|5102|
|Specimens Feed Service|unite.specimens.feed|feed.specimens.unite.net|80|5104|
|Genome Feed Service|unite.genome.feed|feed.genome.unite.net|80|5106|
|Ensembl Data Service|unite.ensembl.data|data.ensembl.unite.net|80|5200|
|Ensembl VEP Service|unite.ensembl.vep|vep.ensembl.unite.net|80|5202|

> [!NOTE]
> Only Web portal ports are publicly exposed (*0.0.0.0*). Ports of other components are exposed to host machine local network only (*127.0.0.1*).
