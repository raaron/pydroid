#!/usr/bin/python

# Use this installation method if you want to modify and test pydroid.
# Pydroid will then get the source from this directories instead of finding
# them automatically in dist-packages directory after an installation
# with setup.py.

# Installs pydroid on this system as setup.py would do it with 3 differences:
#   - pydroid source code comes not from python dist-packages, but from
#       this local copy of the pydroid git repo
#   - pydroid source code comes not from python dist-packages, but from
#       another local copy of the pydroid git repo
#   - bash autocompletion won't work after this installation method

# Example usage:
# ./install_pydroid_editable.py

import re
import subprocess
import os
import shutil


DEV_DIR = os.path.dirname(os.path.abspath(__file__))
PYDROID_ROOT_DIR = os.path.dirname(DEV_DIR)
BIN_DIR = os.path.join(PYDROID_ROOT_DIR, 'bin')
PYDROID_FILE = os.path.join(BIN_DIR, 'pydroid')
PYDROID_TMP_FILE = os.path.join(BIN_DIR, 'pydroid_tmp')
CONF_DIR = os.path.join(os.path.expanduser("~"), '.pydroid')
CONF_FILE = os.path.join(CONF_DIR, 'deploy.conf')
CONF_BAK_FILE = os.path.join(CONF_DIR, 'deploy_bak.conf')


def remove_old_installation():
    """Remove old pydroid installation if any."""

    print "Removing previous installation of pydroid if any..."
    subprocess.call(['sudo', 'bash',
                     os.path.join(DEV_DIR, "remove_pydroid_installation.sh")])


def restore_config_file():
    """Restore the config file if a backup exists, otherwise show a warning."""

    if os.path.exists(CONF_BAK_FILE):
        print "Restoring pydroid configuration from backup..."
        shutil.copy(CONF_BAK_FILE, CONF_FILE)
    else:
        print_green("You need to adapt the pydroid config file at:\n%s" %
                    CONF_FILE)


def print_green(txt):
    """Print green console output."""

    print '\033[92m' + txt + '\033[0m'


remove_old_installation()


# Create a temporary file containing a modified version of the bin/pydroid file
# to let it find the pydroid source code later.
with open(PYDROID_FILE, "r") as src:
    with open(PYDROID_TMP_FILE, "w") as dest:
        old_regex = "# sys.path.insert"
        new_regex = "sys.path.insert"
        dest.write(re.sub(old_regex, new_regex, src.read()))


print "Copying pydroid script to /usr/local/bin/pydroid..."
subprocess.call(['sudo', 'chmod', '+x', PYDROID_TMP_FILE])
subprocess.call(['sudo', 'mv', PYDROID_TMP_FILE, '/usr/local/bin/pydroid'])

restore_config_file()
