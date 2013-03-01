#!/usr/bin/python

import sys
import os
import re
import shutil
import ConfigParser

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
CONFIG_FILE = "project.conf"


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
    new_package_name = '.'.join([new_domain, new_name])
    conf = ConfigParser.ConfigParser()
    conf.read(CONFIG_FILE)
    old_name = conf.get("General", "app_name")
    old_package_name = conf.get("General", "package_name")

    shutil.move("%s.pro" % old_name, "%s.pro" % new_name)

    files = ["main.h",
             "android/src/org/kde/necessitas/origo/QtActivity.java",
             "android/AndroidManifest.xml"]
    for fn in files:
        python_sed(old_package_name, new_package_name, fn)

    files = ["%s.pro" % new_name,
             "android/AndroidManifest.xml",
             "android/res/values/strings.xml",
             "android/build.xml"]
    for fn in files:
        python_sed(old_name, new_name, fn)

    parent_dir = os.path.dirname(PROJECT_DIR)

    try:
        shutil.move(os.path.join(parent_dir, old_name),
                    os.path.join(parent_dir, new_name))
    except IOError:
        pass

    conf.set("General", "app_name", new_name)
    conf.set("General", "package_name", new_package_name)
    with file(CONFIG_FILE, "w") as fobj:
        conf.write(fobj)


def main(argv):
    """
    Check if a new app name and the new domain were specified and whether the
    no directory with the new name already exists. If so, rename the project,
    else print an error message.
    """

    if len(argv) != 2:
        print "Error: Invalid argument count: got $d instead of 2." % len(argv)
        print "Syntax: ./rename new_app_name new_domain"
        sys.exit(1)
    else:
        new_name, new_domain = argv
        new_project_dir = os.path.join(os.path.dirname(PROJECT_DIR), new_name)
        if os.path.exists(new_project_dir):
            print "Error: A directory with name %s already exists." % new_name
            sys.exit(1)
        else:
            rename_project(new_name, new_domain)
            print "Project successfully renamed."
            print "Execute the following to adapt the shell prompt:"
            print "cd ../%s" % new_name

if __name__ == "__main__":
    main(sys.argv[1:])
