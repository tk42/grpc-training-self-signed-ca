#!/bin/bash -x

NAME=$1
if [ -z "${NAME}" ]; then
  echo "Server name is required."
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
cp /etc/pki/tls/openssl.cnf /work/openssl.cnf
echo -e "\n[ SAN ]\nsubjectAltName = DNS:${NAME}\n" >> /work/openssl.cnf
openssl req -new \
  -config /work/openssl.cnf -reqexts SAN \
  -key ${PRIVATE} -out ${NAME}.csr -sha256 -subj "${SUBJECT}"

cat -n /work/openssl.cnf

echo -e "subjectAltName=DNS:${NAME}\n" >> /work/x509.ext
openssl x509 -req -days ${TTL} \
  -extfile /work/x509.ext \
  -CA /ca/ca.crt \
  -CAkey /ca/ca.pem \
  -CAcreateserial \
  -CAserial /ca/ca.seq \
  -in ${NAME}.csr \
  -out /out/${NAME}.crt
cat /ca/ca.crt >> /out/${NAME}.crt

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
