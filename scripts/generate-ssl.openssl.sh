#!/bin/bash

pwd=$(jq -r .ssl.password ../secrets.json)

tput setaf 6; echo "Generating self-signed SSL certificate"; tput sgr0
echo ""

tput setaf 4; echo "Removing existing one ..."; tput sgr0
rm -r -f ../ssl
mkdir ../ssl
echo "done"
echo ""

tput setaf 4; echo "Generating RSA key ..."; tput sgr0
openssl genrsa \
        -des3 \
        -out ../ssl/unite.key \
        -passout pass:$pwd \
        4096
echo "RSA private key palced to ../ssl/unite.key"
echo ""

tput setaf 4; echo "Generating certificate ..."; tput sgr0
openssl req \
       -key ../ssl/unite.key \
       -new \
       -x509 -days 1095 -out ../ssl/unite.cert \
       -subj "/C=DE/ST=Baden Wurttemberg/L=Heidelberg/O=DKFZ/CN=DKFZ" \
       -passin pass:$pwd
echo "Certificate palced to ../ssl/unite.cert"
echo ""

tput setaf 4; echo "Converting PEM to PFX ..."; tput sgr0
openssl pkcs12 \
        -inkey ../ssl/unite.key \
        -in ../ssl/unite.cert \
        -export \
        -out ../ssl/unite.pfx \
        -passin pass:$pwd \
        -passout pass:$pwd
echo "Certificate placed to ../ssl/unite.pfx"
