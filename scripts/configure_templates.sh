#!/usr/bin/env bash

# Variables
NFS_CLUSTER_EXPORT=${NFS_CLUSTER_EXPORT:-''}
NFS_INSTANCE_GUID=${NFS_INSTANCE_GUID:-''}
NFS_HOST=${NFS_HOST:-''}
ROOT_DIR=${ROOT_DIR:-''}

# Functions

## Export variables to replace in the templates
export_vars()
{
    export NFS_CLUSTER_EXPORT
    export NFS_INSTANCE_GUID
    export NFS_HOST
    export ROOT_DIR
}

## Unset variables for safety
unset_vars()
{
    unset NFS_CLUSTER_EXPORT
    unset NFS_INSTANCE_GUID
    unset NFS_HOST
    unset ROOT_DIR
}

## Deploy templates
deploy_templates()
{
    ## Find all .yaml.tmpl files in the repository recursively
    find "${ROOT_DIR}" -type f -name '*.yaml.tmpl' | while read -r TMPL_FILE; do
    
        # Define the output file name by removing the .tmpl extension
        YAML_FILE="${TMPL_FILE%.tmpl}"
    
        # Use envsubst to replace variables in the .tmpl file and create the .yaml file
        envsubst < "${TMPL_FILE}" > "${YAML_FILE}"
    
        echo "Created ${YAML_FILE}"
    done
}

# Logic

export_vars
deploy_templates
unset_vars
