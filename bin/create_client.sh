#!/bin/bash -x

NAME=$1
if [ -z "${NAME}" ]; then
  echo "Client name is required."
  exit 1
fi

SETTING_JSON=/setting/${NAME}.json
if [ ! -e ${SETTING_JSON} ]; then
  echo "${SETTING_JSON} is not found."
  exit 1
fi

TTL=`cat ${SETTING_JSON} | jq -r .ttl`
SUBJECT=`cat ${SETTING_JSON} | jq -r .subject`
PRIVATE=/out/${NAME}.pem

if [ ! -e ${PRIVATE} ]; then
  openssl genrsa -out ${PRIVATE} 2048
fi
openssl req -new -key ${PRIVATE} -out /out/${NAME}.csr -subj "${SUBJECT}"

openssl x509 -req -days ${TTL} \
  -CA /ca/ca.crt \
  -CAkey /ca/ca.pem \
  -CAcreateserial \
  -CAserial /ca/ca.seq \
  -in /out/${NAME}.csr \
  -out /out/${NAME}.crt

openssl pkcs12 -export -clcerts \
  -inkey ${PRIVATE} \
  -in /out/${NAME}.crt \
  -out /out/${NAME}.p12 \
  -passout pass:

openssl pkcs8 \
  -in /out/${NAME}.pem \
  -topk8 \
  -out /out/${NAME}.pkcs8.pem \
  -nocrypt \
  -v1 PBE-SHA1-3DES
