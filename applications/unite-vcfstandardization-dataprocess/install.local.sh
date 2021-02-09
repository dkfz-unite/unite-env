#!/bin/bash

USAGE="install.local.sh <path_to_host_files>"
if [ $# -lt 1 ]
  then
    echo "No file source directory included in command line. Using '/tmp'"
    volume="/tmp"
else
	volume=$1
fi

echo "# Cleaning up source code directory"
rm -r -f src

echo "# Cloning fresh code to source code directory"
currentdir=$(pwd)
echo "currentdir =${currentdir}"
mkdir -p src
chmod -R 777 src

cd $currentdir/src

git clone https://github.com/dkfz-unite/unite-python-core.git UNITEmsc
git clone https://github.com/dkfz-unite/unite-vcfstandardization-service.git UNITEvcfstandardization

cd $currentdir
#cp -p ./src/UNITEvcfstandardization/Dockerfile . 

echo "# Installing UNITE Web application (LOCAL)"
HOSTPATH=$volume docker-compose -p '' -f docker-compose.local.yml up -d --build 

