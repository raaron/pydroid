#!/usr/bin/env bash

# Removes unnecessary files and directories from the python library.

# Example usage:
# ./cleanup_python_lib.sh

DEV_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DEV_DIR/../src/pydroid/framework/project_skeleton/libs/python27/lib/python2.7

# Remove and .py source files
find . -name '*.pyo' -delete

# Remove tests
find . -depth -type d -name 'test' -exec rm -rf {} \;
find . -depth -type d -name 'tests' -exec rm -rf {} \;

# Remove egg infos in site packages
find . -name '*.egg-info' -delete

# Remove unnecessary packages
rm -rf idlelib

# Remove pdb doc file
rm -f pdb.doc

echo Done.