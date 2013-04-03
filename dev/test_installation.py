#!/usr/bin/python

# Tests if using pydroid via python API by creating and deploying an app works.
# This test will fail, if you installed pydroid by using the
# install_pydroid_editable.py script.

# Example usage:
# ./test_installation.py

import os

from pydroid.create_example import create_example
from pydroid.complete_deploy import complete_deploy
from pydroid.rename import rename

TEST_DIR = os.path.join(os.path.expanduser('~'), 'pydroid_test')

os.chdir(TEST_DIR)
create_example(["qt_components"])
os.chdir(os.path.join(TEST_DIR, 'qt_components_example'))
rename(['installation_test_example', 'com.example'])
os.chdir(os.path.dirname(os.getcwd()))
app_dir = os.path.join(TEST_DIR, 'installation_test_example')
os.chdir(app_dir)
complete_deploy()
