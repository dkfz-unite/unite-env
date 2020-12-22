#!/bin/bash

pwd=$(jq -r .ssl.password ../secrets.json)

tput setaf 6; echo "Generating self-signed SSL certificate"; tput sgr0
echo ""

tput setaf 4; echo "Removing existing one ..."; tput sgr0
rm -r -f ../ssl
mkdir ../ssl
echo "done"
echo ""

tput setaf 4; echo "Generating certificate ..."; tput sgr0
dotnet dev-certs https -ep ../ssl/unite.pfx -p $pwd
echo "Certificate placed to ../ssl/unite.pfx"
