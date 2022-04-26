#!/bin/bash

if [ ! -d "../ssl" ] 
then
  mkdir ../ssl
fi

cd ../ssl

if [ -z "$1" ]
then
  echo "Generating ssl certificate for localhost"
  mkcert -key-file unite-key.pem -cert-file unite-cert.pem localhost 127.0.0.1 ::1
else
  echo "Generating ssl certificate for '$1'"
  mkcert -key-file unite-key.pem -cert-file unite-cert.pem $1 localhost 127.0.0.1 ::1
fi

chmod 600 unite-key.pem
chmod 600 unite-cert.pem 

cd ../scripts
