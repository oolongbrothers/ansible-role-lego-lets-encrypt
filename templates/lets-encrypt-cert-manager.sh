#! /usr/bin/env bash

set -euxo pipefail

EXTRA_PARAMETERS=""
if [[ -v LETS_ENCRYPT_RESOURCE_PROVIDER ]]; then
    EXTRA_PARAMETERS="${EXTRA_PARAMETERS} --dns=${LETS_ENCRYPT_RESOURCE_PROVIDER}"
elif [[ -v LETS_ENCRYPT_RESOURCE_WEBROOT ]]; then
    EXTRA_PARAMETERS="${EXTRA_PARAMETERS} --http --http.webroot=${LETS_ENCRYPT_RESOURCE_WEBROOT}"
fi

if [[ -v LETS_ENCRYPT_CREATE_CONCATENATED_PEM_FILE ]]; then
    EXTRA_PARAMETERS="${EXTRA_PARAMETERS} --pem"
fi

if [[ -v LETS_ENCRYPT_USE_EXTERNAL_CSR ]]; then
    EXTRA_PARAMETERS="${EXTRA_PARAMETERS} --csr=${LETS_ENCRYPT_DIRECTORY_PATH}/requests/${LETS_ENCRYPT_RESOURCE_COMMON_NAME_ESCAPED}.csr"
fi

if [[ -f "${LETS_ENCRYPT_DIRECTORY_PATH}/certificates/${LETS_ENCRYPT_RESOURCE_COMMON_NAME_ESCAPED}.crt" ]]; then
    # renew the certificate
    /usr/bin/lego \
        --domains="${LETS_ENCRYPT_RESOURCE_COMMON_NAME}" \
        --path="${LETS_ENCRYPT_DIRECTORY_PATH}" \
        --email="${LETS_ENCRYPT_ACCOUNT_EMAIL}" \
        --server="${LETS_ENCRYPT_SERVER}" \
        ${EXTRA_PARAMETERS} \
        --accept-tos \
        renew \
        --days "${LETS_ENCRYPT_RENEW_LIMIT}"
else
    # Register an account, then create and install the certificate
    /usr/bin/lego \
        --domains="${LETS_ENCRYPT_RESOURCE_COMMON_NAME}" \
        --path="${LETS_ENCRYPT_DIRECTORY_PATH}" \
        --email="${LETS_ENCRYPT_ACCOUNT_EMAIL}" \
        --server="${LETS_ENCRYPT_SERVER}" \
        ${EXTRA_PARAMETERS} \
        --accept-tos \
        run
fi
