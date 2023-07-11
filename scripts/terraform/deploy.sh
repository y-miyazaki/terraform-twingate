#!/bin/bash
set -e
DIR=${1:-./}

if [ -z "${TWINGATE_URL}" ] || [ -z "${TWINGATE_NETWORK}" ] || [ -z "${TWINGATE_API_TOKEN}" ]; then
    echo "can't set TWINGATE_URL/TWINGATE_NETWORK/TWINGATE_API_TOKEN."
    exit 1
fi

cd $DIR
echo "#--------------------------------------------------------------"
echo "# tfenv install ($PWD)"
echo "#--------------------------------------------------------------"
tfenv install
echo "#--------------------------------------------------------------"
echo "# terraform init ($PWD)"
echo "#--------------------------------------------------------------"
# terraform init -reconfigure -backend-config=terraform."${ENV}".tfbackend
terraform init
echo "#--------------------------------------------------------------"
echo "# terraform apply ($PWD)"
echo "#--------------------------------------------------------------"
terraform apply --auto-approve -var-file=terraform."${ENV}".tfvars
