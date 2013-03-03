#!/usr/bin/python

# Creates a new pydroid project.

import sys
import os
import json
import shutil
import ConfigParser

from script_utils import PYDROID_DIR, PROJECT_DIR
FRAMEWORK_LIBS_DIR = os.path.join(PYDROID_DIR, 'framework', 'libs')
CONFIG_FILE = os.path.join(FRAMEWORK_LIBS_DIR, 'libs.conf')


def add_library_to_project(name):
    """Check if this library exists and if so, add it to the project."""

    conf = ConfigParser.ConfigParser()
    conf.read(CONFIG_FILE)
    src_dir, dst_dir = json.loads(conf.get('libs', name))
    src_dir = os.path.join(FRAMEWORK_LIBS_DIR, src_dir)
    dst_dir = os.path.join(PROJECT_DIR, dst_dir, '/')
    if os.path.exists(dst_dir):
        print "The destination directory for the library already exists:"
    else:
        shutil.copytree(src_dir, dst_dir, symlinks=True)
        print "Added library at:"
    print dst_dir


def add_library(argv):
    """Check if a library name was specified, else print an error message."""

    if len(argv) != 1:
        print "Error: Invalid argument count: got %d instead of 2." % len(argv)
        print "Syntax: ./add_library lib-name"
        sys.exit(1)
    else:
        add_library_to_project(argv[0])

if __name__ == "__main__":
    # add_library_to_project('qt-components')
    add_library(sys.argv[1:])
