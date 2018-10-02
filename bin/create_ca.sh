#!/bin/bash -x

SETTING_JSON="/ca/setting.json"
if [ ! -e ${SETTING_JSON} ]; then
  echo "${SETTING_JSON} is not found."
  exit 1
fi

TTL=`cat ${SETTING_JSON} | jq -r .ttl`
SUBJECT=`cat ${SETTING_JSON} | jq -r .subject`

PRIVATE=/ca/ca.pem
CERT=/ca/ca.crt
CRL=/ca/ca.crl

if [ ! -e ${PRIVATE} ]; then
  echo "Create private file."
  openssl genrsa -out ${PRIVATE} 2048
fi

cp /etc_pki_CA/index.txt /etc/pki/CA/index.txt
cp /etc_pki_CA/crlnumber /etc/pki/CA/crlnumber
if [ -e /etc_pki_CA/crlnumber.old ]; then
  cp /etc_pki_CA/crlnumber.old /etc/pki/CA/crlnumber.old
fi

openssl req -new -x509 -days ${TTL} -key ${PRIVATE} -out ${CERT} -subj "${SUBJECT}"
openssl ca -name CA_default -gencrl -keyfile ${PRIVATE} -cert ${CERT} -out ${CRL} -crldays ${TTL}

cp /etc/pki/CA/index.txt /etc_pki_CA/index.txt
cp /etc/pki/CA/crlnumber /etc_pki_CA/crlnumber
cp /etc/pki/CA/crlnumber.old /etc_pki_CA/crlnumber.old
