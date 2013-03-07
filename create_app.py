#!/usr/bin/python

# Creates a new pydroid project.

import sys
import os

import create_example
from path_utils import skeleton_dir

EXAMPLE_NAME = 'hello_world'


def create_app(argv):
    """
    Check if an app name and the domain were specified and whether the
    skeleton project exists. If so, create the new project, else print
    an error message.
    """
    if len(argv) != 2:
        print "Error: Invalid argument count: got %d instead of 2." % len(argv)
        print "Syntax: ./pydroid app_name domain"
        sys.exit(1)
    elif not os.path.exists(skeleton_dir()):
        print "Error: Could not find the template for creating the project."
        print "Expected the template at:", skeleton_dir()
        sys.exit(1)
    else:
        create_example.create_example_project(EXAMPLE_NAME, argv[0], argv[1])

if __name__ == "__main__":
    # create_app(["asdf", "foo.bar"])
    create_app(sys.argv[1:])
