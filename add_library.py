#!/usr/bin/python

# Adds a new library from the framework to the app.

import sys
import os
import shutil
import ConfigParser

from path_utils import *


def add_library_to_project(lib_name):
    """Check if this library exists and if so, add it to the project."""

    conf = ConfigParser.ConfigParser()
    conf.read(libs_config_file())
    src_dir = os.path.join(framework_libs_dir(), lib_name)
    dst_dir = os.path.join(project_dir(), conf.get('libs', lib_name), lib_name)
    if os.path.exists(dst_dir):
        print "Error: The destination directory for the library already exists:"
        print dst_dir
        return False
    else:
        shutil.copytree(src_dir, dst_dir, symlinks=True)
        print "Successfully added library at:"
        print dst_dir
        return True


def add_library(argv):
    """Check if a library name was specified, else print an error message."""

    if len(argv) != 1:
        print "Error: Invalid argument count: got %d instead of 1." % len(argv)
        print "Syntax: ./add_library lib_name"
        sys.exit(1)
    else:
        add_library_to_project(argv[0])

if __name__ == "__main__":
    # add_library_to_project('qt_components')
    add_library(sys.argv[1:])
