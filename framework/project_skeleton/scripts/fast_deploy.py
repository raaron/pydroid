#!/usr/bin/python

import sys
import os
import ConfigParser
import subprocess
import compileall


PROJECT_DIR = os.getcwd()
print PROJECT_DIR
APP_DIR = os.path.join(PROJECT_DIR, 'app')
CONFIG_FILE = os.path.join(PROJECT_DIR, "project.conf")

conf = ConfigParser.ConfigParser()
conf.read(CONFIG_FILE)
PACKAGE_NAME = conf.get("General", "package_name")
ADB_PATH = conf.get("General", "adb_path")

PUBLIC_ANDROID_DIR = "/sdcard"
ANDROID_APP_DIR = "/data/data/%s/files/" % PACKAGE_NAME
CMD_PREFIX = [ADB_PATH, "shell", "run-as", PACKAGE_NAME]
LS_CMD = CMD_PREFIX + ["ls", ANDROID_APP_DIR]
START_APP_CMD = [ADB_PATH, "shell", "am", "start", "-n", "%s/org.kde.necessitas.origo.QtActivity" % PACKAGE_NAME]
STOP_APP_CMD = [ADB_PATH, "shell", "am", "force-stop", PACKAGE_NAME]
LOG_CMD = [ADB_PATH, "shell", "logcat"]
CLEAR_LOG_CMD = LOG_CMD + ["-c"]


def remove_old_files():
    """
    Removes everything in the app from "/data/data/PACKAGE_NAME/files/" except of
    the "python" library.
    """
    p = subprocess.Popen(LS_CMD, shell=False, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = p.communicate()
    if err:
        print err
        sys.exit(0)

    files = [fn for fn in out.split('\r\n') if fn and fn != 'python']
    print "Removing:", files
    for fn in files:
        rm_cmd = CMD_PREFIX + ["rm", os.path.join(ANDROID_APP_DIR, fn)]
        subprocess.call(rm_cmd)


def copy_files():
    """
    Bytecompile all python source files, copy them together with the .qml files
    to the android device.
    """
    if not compileall.compile_dir(APP_DIR, maxlevels=100, quiet=True):
        sys.exit(0)
    for root, dirs, files in os.walk(APP_DIR):
        for fn in files:
            if not fn.endswith('.py'):
                src_path = os.path.join(APP_DIR, fn)
                dest_path = os.path.join(ANDROID_APP_DIR, fn)
                sd_card_fn = os.path.join(PUBLIC_ANDROID_DIR, fn)
                push_cmd = [ADB_PATH, "push", src_path, sd_card_fn]
                subprocess.call(push_cmd)
                print "Copying:", src_path
                cat_cmd = [ADB_PATH, "shell", "su -c 'cat %s > %s'" % (sd_card_fn, dest_path)]
                subprocess.call(cat_cmd)


def restart_app():
    """
    Stop the app if an older version is still running.
    Run the new version of the app on the device.
    Output the logcat.
    """
    subprocess.call(STOP_APP_CMD)
    subprocess.call(START_APP_CMD)
    # subprocess.call(CLEAR_LOG_CMD)
    # subprocess.call(LOG_CMD)


def main():
    """
    Remove the old python and qml source files, copy the current files to
    the device, (re)start the app, show log output.
    """
    remove_old_files()
    copy_files()
    restart_app()


if __name__ == "__main__":
    main()
