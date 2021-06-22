#!/usr/bin/env bash

set -euxo pipefail;

LETS_ENCRYPT_RESOURCE_COMMON_NAME_ESCAPED=$1
CERT_BASE_PATH=${LETS_ENCRYPT_DIRECTORY_PATH}/certificates/${LETS_ENCRYPT_RESOURCE_COMMON_NAME_ESCAPED}

OCSP_URL="$(openssl x509 -noout -ocsp_uri -in ${CERT_BASE_PATH}.crt)";

openssl ocsp -no_nonce -respout "${CERT_BASE_PATH}.pem.ocsp" \
  -issuer "${CERT_BASE_PATH}.issuer.crt" \
  -verify_other "${CERT_BASE_PATH}.issuer.crt" \
  -cert "${CERT_BASE_PATH}.crt" \
  -url "${OCSP_URL}";

chown --reference="${CERT_BASE_PATH}.pem" "${CERT_BASE_PATH}.pem.ocsp";
chmod --reference="${CERT_BASE_PATH}.pem" "${CERT_BASE_PATH}.pem.ocsp";
