#!/usr/bin/env bash

# Variables
VELERO_INSTALL_DIR=${VELERO_INSTALL_DIR:-'/usr/local/bin'}
VELERO_REPO=${VELERO_REPO:-'https://api.github.com/repos/vmware-tanzu/velero'}
VELERO_VERSION_URL=''
HOST_OS=''
HOST_ARCH=''

# Functions

## Check that required commands are available
check_commands()
{
  # Check for grep
  if ! sudo -i -u ${BUILDUSER} command -v grep &> /dev/null; then
    echo "grep could not be found!"
    exit 1
  fi

  # Check for cURL
  if ! sudo -i -u ${BUILDUSER} command -v curl &> /dev/null; then
    echo "cURL could not be found!"
    exit 1
  fi

  # Check for wget
  if ! sudo -i -u ${BUILDUSER} command -v wget &> /dev/null; then
    echo "wget could not be found!"
    exit 1
  fi

  # Check for velero
  if ! sudo -i -u ${BUILDUSER} command -v velero &> /dev/null; then
    echo "velero already installed!"
    exit 1
  fi
}

## Clean up files
cleanup()
{
  rm -rf velero-*-${HOST_OS}-${HOST_ARCH}*
}

## Install
install()
{
  # Get the appropriate version URL
  VELERO_VERSION_URL=$(curl -s ${VELERO_REPO}/releases/latest \
    | grep download_url \
    | grep tar.gz \
    | cut -d '"' -f 4 \
    | grep ${HOST_OS} \
    | grep ${HOST_ARCH})

  wget ${VELERO_VERSION_URL}
  tar xvzf $(basename ${VELERO_VERSION_URL})
  cp velero-*-${HOST_OS}-${HOST_ARCH}/velero ${VELERO_INSTALL_DIR}/velero
  chown root:root ${VELERO_INSTALL_DIR}/velero
  chmod 755 ${VELERO_INSTALL_DIR}/velero
}

## Set important variables
set_vars()
{
  # Set the architecture
  if [[ "$(arch)" == "aarch64" ]]; then
    HOST_ARCH="arm64"
  else
    HOST_ARCH="aarch64"
  fi

  # Set the operating system
  if [[ "${OSTYPE}" == "linux*" ]]
    HOST_OS="linux"
  elif [[ "${OSTYPE}" == "darwin*" ]]
    HOST_OS="darwin"
  else
    HOST_OS="linux"
  fi
}

## Display usage information
usage()
{
  echo "Usage: [Environment Variables] install_velero.sh [-h]"
  echo "  Environment Variables"
  echo "    VELERO_INSTALL_DIR         filesystem location for velero (default: '/usr/local/bin/')"
  echo "    VELERO_REPO                location of the upstream repo for velero (default: 'https://api.github.com/repos/vmware-tanzu/velero')"
}

# Logic

## Argument parsing
while [[ "$1" != "" ]]; do
  case $1 in
    -h | --help ) usage
                  exit 0
                  ;;
    * )           usage
                  exit 1
  esac
  shift
done

check_commands
set_vars
install
cleanup