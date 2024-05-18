#!/usr/bin/env bash

# Variables
BACKUP_PV_DIR=${BACKUP_PV_DIR:-'.'}

# Functions

## Backup
backup()
{
  # Get a list of all persistent volumes
  PV_LIST=$(kubectl get pv -o go-template="{{range .items}}{{.metadata.name}}{{\"\n\"}}{{end}}")

  # Loop all PVs found
  for PV_NAME in ${PV_LIST}; do
    PV_DETAILS=$(kubectl get pv "${PV_NAME}" -o yaml)

    # Save to a file
    echo "${PV_DETAILS}" > "${BACKUP_PV_DIR}/${PV_NAME}-raw.yaml"

    # Add the last-applied-configuration annotation
    LAST_APPLIED=$(cat "${BACKUP_PV_DIR}/${PV_NAME}-raw.yaml" | kubectl create --dry-run=client -o yaml -f -)
    kubectl annotate --overwrite -f "${BACKUP_PV_DIR}/${PV_NAME}-raw.yaml" \
      kubectl.kubernetes.io/last-applied-configuration="$(echo "${LAST_APPLIED}" | \
      sed 's/"/\\"/g' | \
      tr -d '\n')" -o yaml \
      > "${BACKUP_PV_DIR}/${PV_NAME}.yaml"

    # Cleanup
    rm "${BACKUP_PV_DIR}/${PV_NAME}-raw.yaml"
    echo "Created ${BACKUP_PV_DIR}/${PV_NAME}.yaml"
  done
}

# Logic

backup