#!/usr/bin/env bash

# Variables
BACKUP_PV_DIR=${BACKUP_PV_DIR:-'.'}

# Functions

## Backup
backup()
{
  # Get a list of all persistent volumes
  PV_LIST=$(kubectl get pv -o go-template="{{range .items}}{{.metadata.name}}{{\n}}{{end}}")

  # Loop through each persistent volume
  for PV_NAME in ${PV_LIST}; do
    # Describe the persistent volume
    PV_DETAILS=$(kubectl get pv ${PV_NAME} -o yaml)

    # Write the description to a YAML file named after the PV
    echo "${PV_DETAILS}" > "${BACKUP_PV_DIR}/${PV_NAME}.yaml"

    # Inform user
    echo "Created ${BACKUP_PV_DIR}/${PV_NAME}.yaml"
  done
}

# Logic

backup