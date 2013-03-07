#!/usr/bin/python

# Use this script if you want to rename your project. Manual renaming may leave
# your project in an unstable state if you forget renaming in any location.

import sys
import os
import re
import shutil
import ConfigParser

from path_utils import pydroid_dir, project_dir, app_name, package_name
from path_utils import naming_config_file


def python_sed(old_regex, new_regex, filename):
    """
    Python equivalent for the shell "sed".
    Replace old_regex by new_regex in this file.
    """
    with open(filename, "r") as fobj:
        text = fobj.read()
    with open(filename, "w") as fobj:
        fobj.write(re.sub(old_regex, new_regex, text))


def rename_project(new_name, new_domain):
    """
    Renames all directories and files to the new name and domain and adapts
    the code accordingly.
    """
    old_project_dir = project_dir()
    new_project_dir = os.path.join(os.path.dirname(project_dir()), new_name)
    new_package_name = '.'.join([new_domain, new_name])

    shutil.move("%s.pro" % app_name(), "%s.pro" % new_name)

    files = ["main.h",
             "android/src/org/kde/necessitas/origo/QtActivity.java",
             "android/AndroidManifest.xml"]
    for fn in files:
        python_sed(package_name(), new_package_name, fn)

    files = ["%s.pro" % new_name,
             "android/AndroidManifest.xml",
             "android/res/values/strings.xml",
             "android/build.xml"]
    for fn in files:
        python_sed(app_name(), new_name, fn)

    shutil.move(old_project_dir, new_project_dir)
    os.chdir(new_project_dir)

    conf = ConfigParser.ConfigParser()
    conf.read(naming_config_file())
    conf.set("General", "app_name", new_name)
    conf.set("General", "package_name", new_package_name)
    with file(naming_config_file(), "w") as fobj:
        conf.write(fobj)


def rename(argv):
    """
    Check if a new app name and the new domain were specified and whether the
    no directory with the new name already exists. If so, rename the project,
    else print an error message.
    """

    if len(argv) != 2:
        print "Error: Invalid argument count: got %d instead of 2." % len(argv)
        print "Syntax: ./rename new_app_name new_domain"
        sys.exit(1)
    else:
        new_name, new_domain = argv
        new_project_dir = os.path.join(pydroid_dir(), new_name)
        if os.path.exists(new_project_dir):
            print "Error: A directory with name %s already exists." % new_name
            sys.exit(1)
        else:
            rename_project(new_name, new_domain)
            print "Project successfully renamed."
            print "Execute the following to adapt the shell prompt:"
            print "cd ../%s" % new_name

if __name__ == "__main__":
    rename(sys.argv[1:])
