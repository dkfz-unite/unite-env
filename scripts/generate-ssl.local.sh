#!/bin/bash

PARENT="localhost"

tput setaf 6; echo "Generating self-signed SSL certificate"; tput sgr0
echo ""

tput setaf 4; echo "Removing existing one ..."; tput sgr0
rm -r -f ../ssl
mkdir ../ssl
echo "done"
echo ""

tput setaf 4; echo "Generating config ..."; tput sgr0
echo "[req]
default_bits= 4096
distinguished_name=req
x509_extension = v3_ca
req_extensions = v3_req
[v3_req]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[ alt_names ]
DNS.1 = www.${PARENT}
DNS.2 = ${PARENT}
[ v3_ca ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer
basicConstraints = critical, CA:TRUE, pathlen:0
keyUsage = critical, cRLSign, keyCertSign
extendedKeyUsage = serverAuth, clientAuth" > ../ssl/$PARENT.cnf
echo "Config placed to ../ssl/$PARENT.cnf"
echo ""

tput setaf 4; echo "Generating certificate ..."; tput sgr0
openssl req \
-x509 \
-newkey rsa:4096 \
-sha256 \
-days 365 \
-nodes \
-keyout ../ssl/$PARENT.key \
-out ../ssl/$PARENT.crt \
-subj "/C=DE/ST=Baden-Wurttemberg/L=Heidelberg/O=DKFZ/CN=${PARENT}" \
-extensions v3_ca \
-extensions v3_req \
-config ../ssl/$PARENT.cnf
echo "Certificate placed to ../ssl/$PARENT.crt"
echo "Certificate key placed to ../ssl/$PARENT.key"
echo ""

tput setaf 4; echo "Signing certificate ..."; tput sgr0
openssl x509 -noout -text -in ../ssl/$PARENT.crt
echo "done"