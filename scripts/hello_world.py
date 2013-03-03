#!/usr/bin/python

# Creates a new pydroid project and directly deploys and runs it without
# the QtCreator GUI.

import sys
import os
import pydroid
import shutil

APP_NAME = "hello_world"
DOMAIN = "com.example"
PYDROID_DIR = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))


def hello_world(show_log=True):
    """
    Remove the previous project if any. Create, deploy and run the new one.
    """
    # Remove the previous project and possible corresponding build directories
    for dir_ in [APP_NAME, "%s-build-fc1cb9-Release" % APP_NAME]:
        try:
            shutil.rmtree(dir_)
        except OSError:
            pass

    # Create the new test project
    pydroid.create_new_project(APP_NAME, DOMAIN, override_existing=True)

    # Run it
    os.chdir(os.path.join(PYDROID_DIR, APP_NAME))
    sys.path.append('scripts')
    import complete_deploy
    complete_deploy.complete_deploy(show_log)


if __name__ == "__main__":
    hello_world(show_log=True)
