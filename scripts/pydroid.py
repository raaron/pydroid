#!/usr/bin/python

# Creates a new pydroid project.

import sys
import os
import create_example


PYDROID_DIR = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
SKELETON_DIR = os.path.join(PYDROID_DIR, 'framework', 'project_skeleton')
EXAMPLE_APP = 'hello_world'


def pydroid(argv):
    """
    Check if an app name and the domain were specified and whether the
    skeleton project exists. If so, create the new project, else print
    an error message.
    """
    if len(argv) != 2:
        print "Error: Invalid argument count: got %d instead of 2." % len(argv)
        print "Syntax: ./pydroid app_name domain"
        sys.exit(1)
    elif not os.path.exists(SKELETON_DIR):
        print "Error: Could not find the template for creating the project."
        print "Expected the template at:", SKELETON_DIR
        sys.exit(1)
    else:
        create_example.create_example_project(EXAMPLE_APP, argv[0], argv[1])

if __name__ == "__main__":
    # pydroid(["asdf", "foo.bar"])
    pydroid(sys.argv[1:])
