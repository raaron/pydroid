#!/usr/bin/env bash

cd src/pydroid/framework/project_skeleton/libs/python27/lib/python2.7

echo This is a dangerous script, since it will recursively delete all .pyo and other files from the following directory:
echo
echo `pwd`
echo

read -p "Do you want to clean up this directory [y/n]?" INPUT
if [ $INPUT = "y" ]; then

  # Remove and .py source files
  find . -name '*.pyo' -delete

  # Remove tests
  find . -type d -name 'test' -print -exec rm -rf {} \;

  # Remove egg infos in site packages
  find . -name '*.egg-info' -delete

  # Remove unnecessary packages
  rm -rf idlelib

  # Remove pdb doc file
  rm -f pdb.doc
fi