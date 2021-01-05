#!/bin/bash

USAGE="install.local.sh <ODCF_dir_to_parse> <filetype_to_parse>"
if [ $# -lt 2 ]
  then
    echo "$USAGE"
    exit 1
fi

echo "# Cleaning up source code directory"
rm -r -f src

echo "# Cloning fresh code to source code directory"
currentdir=$(pwd)
mkdir -p src
chmod -R 777 src

cd $currentdir/src

### Clone in from repo ###
git clone https://b240-phabricator.dkfz-heidelberg.de/source/UNITE-OTP.git UNITEotp
### END Clone in from repo ###
git clone https://b240-phabricator.dkfz-heidelberg.de/source/UNITE-MSC.git UNITEmsc
git clone https://b240-phabricator.dkfz-heidelberg.de/source/BODA-PyVCF.git PyVCF

cp -p ./UNITEotp/Dockerfile . 
cp -p ./UNITEotp/fuse.conf . 

cd $currentdir

echo "# Installing UNITE Web application (LOCAL)"
ODCF_REMOTE_DIR=$1 ODCF_FILE_EXTENSION=$2 docker-compose -p '' -f docker-compose.local.yml up -d --build 

