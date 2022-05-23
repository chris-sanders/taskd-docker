#!/bin/sh

TASKHOME="/var/taskd"
PKI="$TASKHOME/pki"

cd $PKI

if [ "$EXPIRATION_DAYS" ]; then
  echo "Setting expiration to $EXPIRATION_DAYS"
  sed -i "s/EXPIRATION_DAYS=.*/EXPIRATION_DAYS=$EXPIRATION_DAYS/g" vars
fi

if [ ! -f "$PKI/ca.cert.pem" ]; then
  echo "No ca found, generating one."
  ./generate.ca
fi

if [ "$CN" ]; then
  echo "Setting the hostname for the certificates"
  sed -i "s/CN=.*/CN=$CN/g" vars
fi

if [ ! -f "$PKI/server.cert.pem" ]; then
  echo "Creating server certificates"
  ./generate.server
  ./generate.crl
  ./generate.client api
fi

echo "Starting server"
taskd server
