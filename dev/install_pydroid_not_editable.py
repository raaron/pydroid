#!/usr/bin/python

# Use this installation method if you want to install pydroid using setup.py
# The pydroid source code will not be editabel and testable after.

# Example usage:
# ./install_pydroid_not_editable.py

import subprocess
import os

from install_pydroid_editable import PYDROID_ROOT_DIR, restore_config_file

subprocess.call(['sudo', 'python', os.path.join(PYDROID_ROOT_DIR, 'setup.py'),
                 'install'])

# Remove build directories
subprocess.call(['sudo', 'rm', '-rf', os.path.join(PYDROID_ROOT_DIR, 'build')])
subprocess.call(['sudo', 'rm', '-rf', os.path.join(PYDROID_ROOT_DIR, 'dist')])
subprocess.call(['sudo', 'rm', '-rf', os.path.join(PYDROID_ROOT_DIR,
                                                   'pydroid.egg-info')])

restore_config_file()
