#!/usr/bin/env bash

# Variables
NFS_CLUSTER_EXPORT=${NFS_CLUSTER_EXPORT:-''}
NFS_INSTANCE_GUID=${NFS_INSTANCE_GUID:-''}
NFS_HOST=${NFS_HOST:-''}
ROOT_DIR=${ROOT_DIR:-''}

# Logic

## Find all .yaml.tmpl files in the repository recursively
find "${ROOT_DIR}" -type f -name '*.yaml.tmpl' | while read -r TMPL_FILE; do
    # Define the output file name by removing the .tmpl extension
    YAML_FILE="${TMPL_FILE%.tmpl}"

    # Use envsubst to replace variables in the .tmpl file and create the .yaml file
    envsubst < "${TMPL_FILE}" > "${YAML_FILE}"

    echo "Created ${YAML_FILE}"
done
