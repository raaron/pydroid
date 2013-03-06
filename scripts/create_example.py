#!/usr/bin/python

# Create a new example app.

import sys
import os
import json
import shutil
import ConfigParser

import global_script_utils


DOMAIN = "com.example"
APP_NAME_SUFFIX = "_example"

# Add local scripts of the project_skeleton to the path to import some
sys.path.insert(0, global_script_utils.get_local_skeleton_scripts_dir())

from path_utils import examples_dir, skeleton_dir, examples_config_file
from path_utils import pydroid_dir
from script_utils import reload_local_scripts
import rename
import add_library


def setup_project(app_name, domain, override_existing=False):
    """
    Create a new project with name 'app_name' from the skeleton project.
    Returns True if the project could have been created successfully.
    """
    dst = os.path.join(pydroid_dir(), app_name)
    if override_existing:
        try:
            shutil.rmtree(dst)
        except OSError:
            pass

    if os.path.exists(dst):
        print "A directory with name %s already exists." % app_name
        return False
    else:
        shutil.copytree(skeleton_dir(), dst, symlinks=True)
        os.chdir(dst)

        # Load the local scripts of the created project
        reload_local_scripts(skeleton_dir(), dst)

        rename.rename_project(app_name, domain)
        return True


def create_example_project(example_name, app_name, domain, override_existing=False):
    """
    Check if this example exists and if so, create a new project with
    'app_name' for it.
    """
    # Create the project
    project_dir = os.path.join(pydroid_dir(), app_name)
    if setup_project(app_name, domain, override_existing):

        # Insert the sample app
        src_dir = os.path.join(examples_dir(), example_name)
        dst_dir = os.path.join(project_dir, 'app')
        shutil.copytree(src_dir, dst_dir, symlinks=True)

        # Add needed libraries
        conf = ConfigParser.ConfigParser()
        conf.read(examples_config_file())
        libs = json.loads(conf.get(example_name, 'libs'))
        for lib in libs:
            add_library.add_library_to_project(lib)


def create_example(argv):
    """Check if an example name was specified, else print an error message."""

    if len(argv) != 1:
        print "Error: Invalid argument count: got %d instead of 1." % len(argv)
        print "Syntax: ./create_example example_name"
        sys.exit(1)
    else:
        create_example_project(example_name=argv[0],
                               app_name=argv[0] + APP_NAME_SUFFIX,
                               domain=DOMAIN,
                               override_existing=False)


if __name__ == "__main__":
    # create_example_project(example_name='qt_components',
    #                        app_name='qt_components' + APP_NAME_SUFFIX,
    #                        domain=DOMAIN,
    #                        override_existing=True)
    create_example(sys.argv[1:])
