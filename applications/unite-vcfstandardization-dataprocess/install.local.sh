#!/bin/bash

USAGE="install.local.sh <path_to_host_files>"
if [ $# -lt 1 ]
  then
    echo "$USAGE"
    exit 1
fi

echo "# Cleaning up source code directory"
rm -r -f src

echo "# Cloning fresh code to source code directory"
currentdir=$(pwd)
echo "currentdir =${currentdir}"
mkdir -p src
chmod -R 777 src

cd $currentdir/src

git clone https://b240-phabricator.dkfz-heidelberg.de/source/UNITE-MSC.git UNITEmsc
git clone https://b240-phabricator.dkfz-heidelberg.de/source/UNITEvcfstandardization.git UNITEvcfstandardization

cd $currentdir
#cp -p ./src/UNITEvcfstandardization/Dockerfile . 

echo "# Installing UNITE Web application (LOCAL)"
HOSTPATH=$1 docker-compose -p '' -f docker-compose.local.yml up -d --build 

