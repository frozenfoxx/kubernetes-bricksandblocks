#!/usr/bin/env bash

# Variables
CSI_NAME=${CSI_NAME:-''}
CSI_NFS_CLUSTER_EXPORT=${CSI_NFS_CLUSTER_EXPORT:-''}
CSI_NFS_INSTANCE_GUID=${CSI_NFS_INSTANCE_GUID:-''}
CSI_NFS_HOST=${CSI_NFS_HOST:-''}
CSI_NFS_MOUNT=${CSI_NFS_MOUNT:-''}
ROOT_DIR=${ROOT_DIR:-''}

# Functions

## Export variables to replace in the templates
export_vars()
{
    export CSI_NAME
    export CSI_NFS_CLUSTER_EXPORT
    export CSI_NFS_INSTANCE_GUID
    export CSI_NFS_HOST
    export CSI_NFS_MOUNT
    export ROOT_DIR
}

## Unset variables for safety
unset_vars()
{
    unset CSI_NFS_CLUSTER_EXPORT
    unset CSI_NFS_INSTANCE_GUID
    unset CSI_NFS_HOST
    unset CSI_NFS_MOUNT
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
