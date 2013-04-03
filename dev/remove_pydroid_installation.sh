#!/usr/bin/env bash

# Removes previous installation of pydroid (if installed via setup.py) if any.
# Creates a backup of the deploy.conf file for later restore.

# Example usage:
# ./remove_pydroid_installation.sh

PYDROID_CONF_DIR=$HOME/.pydroid
DEPLOY_CONF_FILE=$PYDROID_CONF_DIR/deploy.conf
BACKUP_DEPLOY_CONF_FILE=$PYDROID_CONF_DIR/deploy_bak.conf
DEV_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PYDROID_ROOT_DIR=$DEV_DIR/..

sudo rm -rf /usr/local/lib/python2.7/dist-packages/pydroid*
rm -f /usr/local/bin/pydroid
rm -f /etc/bash_completion.d/pydroid.completion
rm -rf $PYDROID_ROOT_DIR/build
rm -rf $PYDROID_ROOT_DIR/dist
rm -rf $PYDROID_ROOT_DIR/pydroid.egg-info

if [ -f $DEPLOY_CONF_FILE ]
then
  mv $DEPLOY_CONF_FILE $BACKUP_DEPLOY_CONF_FILE
  echo "Made a backup of your pydroid config file at"
  echo $BACKUP_DEPLOY_CONF_FILE.
else
  echo "Pydroid config file does not exist."
fi
