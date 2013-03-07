#!/usr/bin/python

# Use this script if you already made an initial deployment and if you only
# made changes inside the APP_DIR.

# Compiles the current version of the PySide project in APP_DIR and inserts
# the new files on the device. Files outside of APP_DIR remane unchanged.

import sys
import os
import subprocess

# Insert the scripts path of the cwd at the beginning of sys.path to be
# sure to import path_utils in cwd even if the called script is located in
# pydroid/framework (e.g. because it's an external tool for QtCreator).
sys.path.insert(0, os.path.join(os.getcwd(), 'scripts'))

from path_utils import *
import script_utils


def remove_old_files():
    """
    Removes "/data/data/PACKAGE_NAME/files/app", but not any other files
    of the project.
    """

    cmd_prefix = [adb_path(), "shell", "run-as", package_name()]
    ls_cmd = cmd_prefix + ["ls", device_app_dir()]

    p = subprocess.Popen(ls_cmd, shell=False, stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE)
    out, err = p.communicate()
    if err:
        print err
        sys.exit(0)

    files = [fn for fn in out.split('\r\n') if fn and fn != 'python']
    print "Removing:", files
    for fn in files:
        rm_cmd = cmd_prefix + ["rm", os.path.join(device_app_dir(), fn)]
        subprocess.call(rm_cmd)


def copy_files():
    """
    Bytecompile all python source files, copy them together with the .qml files
    to the android device.
    """
    if not script_utils.compile_app_directory():
        sys.exit(0)

    root_len = len(os.path.abspath(app_dir()))
    for root, dirs, files in os.walk(app_dir()):
        archive_root = os.path.abspath(root)[root_len + 1:]

        for d in dirs:
            dest_dir = os.path.join(device_app_dir(), archive_root, d)
            print "Making directory:", dest_dir
            mkdir_cmd = [adb_path(), "shell", "su -c 'mkdir %s'" % dest_dir]

            subprocess.call(mkdir_cmd)

        for fn in files:
            if not fn.endswith('.py'):
                src_path = os.path.join(root, fn)
                dest_path = os.path.join(device_app_dir(), archive_root, fn)
                sd_card_fn = os.path.join(device_sdcard_dir(),
                                          archive_root, fn)

                push_cmd = [adb_path(), "push", src_path, sd_card_fn]
                subprocess.call(push_cmd)
                print "Copying:", src_path
                cat_cmd = [adb_path(), "shell",
                           "su -c 'cat %s > %s'" % (sd_card_fn, dest_path)]
                subprocess.call(cat_cmd)


def fast_deploy(show_log=False):
    """
    Remove the old python and qml source files, copy the current files to
    the device, (re)start the app, show log output.
    """
    remove_old_files()
    copy_files()
    script_utils.restart_app(show_log)


if __name__ == "__main__":
    fast_deploy(show_log=False)
