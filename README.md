## UNITE Environment

UNITE platform installation scripts and configuration files

### Prerequisites
- Software
  - Docker
  - Docker compose
- Command line tools
  - git
  - jq (https://stedolan.github.io/jq)
  - mkcert (https://github.com/FiloSottile/mkcert)
  - wget
  
### Folder Structure
- `applications`
  - `unite` - web portal
    - _docker-compose.yml_ - installation configuration
    - _install.sh_ - installation script
    - _install.local.sh_ - local installation script (from local repository source code)
  - `unite-composer` - composer web API
  - `unite-donors-feed` - donors data feed web API
  - `unite-images-feed` - imaging data feed web API
  - `unite-specimens-feed` - specimens data feed web API
  - `unite-genome-feed` - genome data feed web API
  - `unite-data-migrations` - domain data migrations service
  - `unite-identity-migrations` - identity data migration service
  - `unite-vep` - ensembl Varian Effect Predictor (VEP) web API
- `programs`
  - `postgresql` - data storage
    - _docker-compose.yml_ - installation configuration
    - _docker-compose.**mgmt**.yml_ - management tools installation configuration
    - _install.sh_ - installation script
    - _install.**mgmt**.sh_ - management tools installation script
  - `elasticsearch` - search engine and indices storage
  - `mongodb` - cache and technical data storage
- `scripts`
  - _configure.sh_ - general environment configuration sub-script (used by dedicated environemnt scripts)
  - _configure.**linux**.sh_ - **Linux** environment configuration script
  - _configure.**macos**.sh_ - **MacOS** environment configuration script
  - _generate-ssl.sh_ - SSL certificate generation script
  - _install.sh_ - installation script
  - _uninstall.**hard**.sh_ - **hard** uninstallation script (**removes** data and volumes)
  - _uninstall.**soft**.sh_ - **soft** uninstallation script (**keeps** data and volumes)
- _secrets_template.json_ - JSON configuration template file with all required credentials

### Secrets
All sensitive information is stored in **secrets.json** file. Template of this file is stored in unite-environment repository on github. File has the following structure:
```json
{
    "api": {
        "key": "Defautl32BitApiKeyHasToBeChanged"
    },
    "root": {
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
- _root_ - root **user** and **password** for portal administration
- _github_ - **user** name and personal access **token** with full repository permissions for accessing source code from private **Github** repositories (follow github [instructions](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) to generate it)
- _sql_ - **user** name and **password** for **SQL** server
- _mongodb_ - **user** name and **password** for **MongoDb** server
- _elasticsearch_ - **user** name and **password** for **Elasticsearch** server

To generate passords one of command line tools can be used:
- `openssl rand -base64 22` - to generate 32 byte Base64 string

**!IMPORTANT: ALWAYS CHANGE ALL CREDENTIALS!**

**!IMPORTANT: NEVER COMMIT THIS FILE TO THE REPOSITORY!**

### Installation
1. Download **unite-environment** source files from git repository
1. **Change credentials** in secrets_template.json and **rename** the file to **secrets.json**
1. Open `unite-environment/scripts` folder in terminal
1. Configure environment
   - For **Linux** environment: `sh configure.linux.sh`
   - For **MacOS** environments: `sh configure.macos.sh`
1. Generate SSL certificate
   - For **localhost**: `sh generate-ssl.sh`
   - For **network**: `sh generate-ssl.sh <IP address or domain name>`
1. Install programs and applications
   - `sh install.sh`
1. Install management tools (optional)
   - `sh install.mgmt.sh`
1. Download Ensembl VEP cache
   - Open `unite-environment/applications/unite-vep` folder in terminal
   - Download cache `sh download-cache.sh` (This may take several hours, if download process breaks, run the script again to continue)
   - Extract cache `sh extract-cache.sh`

For custom installation run installation scripts for dedicated programs or applications.

### Uninstallation
To uninstall UNITE platform, run corresponding command from unite-environment/scripts folder:
- To **remove** all services **with all their data**: `sh uninstall.hard.sh`
- To **remove** only services, **but keep all their data**: `sh uninstall.soft.sh`

!Note that uninstallation scripts will remove all containers/images from host machine. If you have other applications runing in docker, clear unite containers and images manually.
