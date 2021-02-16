#!/bin/bash

echo "# Cleaning up source code directory"
rm -r -f src

### Copy in from local dev directory ###
#echo "# Cloning fresh code to source code directory"
#currentdir=$(pwd)
#mkdir -p src
#chmod -R 777 src
#
# echo "Copying in  from local dev directory..."
# cd /home/mikes/WindowsDocuments/eclipse-workspace
# tar -cvf - unite-vcfannotation-service | (cd $currentdir/src; tar xvf - ) 
### END Copy in from local dev directory ###

echo "# Installing UNITE Web application (LOCAL)"
docker-compose -p '' -f docker-compose.localDevelopment.yml up -d --build 

