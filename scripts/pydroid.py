#!/usr/bin/python

# Creates a new pydroid project.

import sys
import os
import shutil


PYDROID_DIR = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
SKELETON_DIR = os.path.join(PYDROID_DIR, 'framework', 'project_skeleton')


def create_new_project(app_name, domain, override_existing=False):
    """Create a new project with name 'app_name' from the skeleton project."""

    dst = os.path.join(PYDROID_DIR, app_name)
    if override_existing:
        try:
            shutil.rmtree(dst)
        except OSError:
            pass

    elif os.path.exists(dst):
        print "A directory with name %s already exists." % app_name
        sys.exit(1)

    shutil.copytree(SKELETON_DIR, dst, symlinks=True)
    os.chdir(dst)
    sys.path.append('scripts')
    import rename
    rename.rename_project(app_name, domain)


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
        create_new_project(argv[0], argv[1])

if __name__ == "__main__":
    # create_new_project(["asdf", "foo.bar"])
    pydroid(sys.argv[1:])
