## UNITE Environemnt

UNITE platform installation scripts and configuration files

### Prerequisites
- Software
  - Docker
  - Docker compose
- Command line tools
  - git
  - jq
  - openssl
  
### Folder Structure
- `applications`
  - `unite` - web portal
    - _docker-compose.**dev**.yml_ - **developer** server installation configuration
    - _docker-compose.**local**.yml_- **local** installation configuration
    - _install.**dev**.sh_ - **developer** server installation script
    - _install.**local**.sh_ - **local** installation script
  - `unite-composer` - composer web API
  - `unite-donors-feed` - donors data feed web API service
  - `unite-mutations-feed` - mutations data feed web API service
  - `unite-migrations` - database migrations service
- `programs`
  - `mysql` - UNITE data storage
    - _docker-compose.**dev**.yml_ - **developer** server installation configuration
    - _docker-compose.**local**.yml_- **local** installation configuration
    - _install.**dev**.sh_ - **developer** server installation script
    - _install.**local**.sh_ - **local** installation script
  - `elasticsearch` - search engine and UNITE data indices storage
  - `mongodb` - developer data storage
- `scripts`
  - _configure.**linux**.sh_ - **Linux** environment configuration file
  - _generate-ssl.**dotnet**.sh_ - SSL certificate generation script for environments **with .net runtime**
  - _generate-ssl.**openssl**.sh_ - SSL certificate generation script for environments **without .net runtime**
  - _install.**dev**.sh_ - **developer** server installation script
  - _install.**local**.sh_ - **local** installation script
  - _uninstall.**hard**.sh_ - **hard** uninstallation script (**removes** data and volumes)
  - _uninstall.**soft**.sh_ - **soft** uninstallation script (**keeps** data and volumes)
- _secrets_template.json_ - JSON configuration file with all required credentials

### Secrets
All sensitive information is stored in **secrets.json** file. Template of this file is stored in unite-environment repository on github. File has the following structure:
```json
{
    "github":{
        "user": "root",
        "token": "Long-t0ken"
    },
    "mysql": {
        "user": "root",
        "password": "Long-p@55w0rd"
    },
    "mongodb": {
        "user": "root",
        "password": "Long-p@55w0rd"
    },
    "elasticsearch": {
        "user": "elastic",
        "password": "Long-p@55w0rd"
    },
    "ssl": {
        "password": "Long-p@55w0rd"
    }
}
```
Each section represents credentials for specific part of the platform services:
- _github_ - **user** name and **token** for accessing source code from private **github** repositories (follow github instructions to generate it)
- _mysql_ - **user** name and **password** for **MySQL** server
- _mongodb_ - **user** name and **password** for **MongoDb** server
- _elasticsearch_ - **user** name and **password** for **Elasticsearch** server
- _ssl_ - **password** for encrypted self signed **SSL** certificate

**!IMPORTAN: ALWAYS CHANGE ALL CREDENTIALS!**

**!IMPORTANT: NEVER COMMIT THIS FILE TO THE REPOSITORY!**

### Installation
1. Download **unite-environment** source files from git repository
1. **Change credentials** in secrets_template.json and **rename** the file to **secrets.json**
1. Open `unite-environment/scripts` folder in terminal
1. Configure environment
   - For **Linux** environment: `sh configure.linux.sh`
   - For **other** environments: `sh configure.sh`
1. Generate SSL certificate
   - For environment **with** .net runtime installed: `sh generate-ssl.dotnet.sh`
   - For environment **without** .net runtime installed: `sh generate-ssl.openssl.sh`
1. Install programs and applications
   - Developer server: `sh install.dev.sh`
   - Local environment: `sh install.local.sh`

### Uninstallation
To uninstall UNITE platform, run corresponding command from unite-environment/scripts folder:
- To **remove** all services **with all their data**: `sh uninstall.hard.sh`
- To **remove** only services, **but keep all their data**: `sh uninstall.soft.sh`
