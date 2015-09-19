#!/bin/bash

if [ "${VIRTUAL_HOST}" = "**None**" ]; then
    unset VIRTUAL_HOST
fi

if [ "${SSL_CERT}" = "**None**" ]; then
    unset SSL_CERT
fi

if [ "${BACKEND_PORTS}" = "**None**" ]; then
    unset BACKEND_PORTS
fi

if [ -n "$SSL_CERT" ]; then
    echo "default SSL certificate provided!"
    mkdir /ssl
    # this certificate MUST be before any others
    echo -e "${SSL_CERT}" > /ssl/default.pem 
    export SSL="ssl crt /ssl"
else
    echo "No default SSL certificate provided"
fi

if [ -n "$EXTRA_CERT_LIST" ]; then
  for cert in $EXTRA_CERT_LIST; do
    var_name="$`echo $cert`"
    cert_body=`eval echo $var_name`
    echo -e "${cert_body}" > /ssl/extra_${cert}.pem
  done
else
  echo "No extra certificates provided"
fi

exec python /app/haproxy.py
