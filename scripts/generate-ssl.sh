#!/bin/bash

if [ ! -d "../ssl" ] 
then
  mkdir ../ssl
fi

cd ../ssl

# Browsers and .NET match the host against subjectAltName only, not against CN
san="DNS:localhost,IP:127.0.0.1,IP:::1"

if [ -z "$1" ]
then
  echo "Generating ssl certificate for localhost"
  host="localhost"
else
  echo "Generating ssl certificate for '$1'"
  host="$1"

  # IPv6 contains ':', IPv4 consists of digits and dots only, anything else is a domain name
  case "$1" in
    *:*) san="IP:$1,$san" ;;
    *[!0-9.]*) san="DNS:$1,$san" ;;
    *) san="IP:$1,$san" ;;
  esac
fi

openssl req -x509 -newkey rsa:4096 -keyout unite-key.pem -out unite-cert.pem -sha256 -days 365 -nodes \
  -subj "/CN=$host" \
  -addext "subjectAltName=$san" \
  -addext "basicConstraints=critical,CA:FALSE" \
  -addext "keyUsage=critical,digitalSignature,keyEncipherment" \
  -addext "extendedKeyUsage=serverAuth"

chmod 600 unite-key.pem
chmod 600 unite-cert.pem

cd ../scripts
