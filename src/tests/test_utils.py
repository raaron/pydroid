import sys
import os
import shutil
import subprocess

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from pydroid.path_utils import adb_path


def remove_directories_if_exist(dirs):
    """Try to remove all directories in dirs."""

    for d in dirs:
        if os.path.exists(d):
            shutil.rmtree(d)


def is_app_running(package_name):
    """Is an app with 'package_name' currently running on the device?"""
    p = subprocess.Popen([adb_path(), 'shell', 'ps'], shell=False,
                         stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output = p.communicate()[0]
    return package_name in output


def stop_app(package_name):
    """Stop the app with 'package_name on the device.'"""
    cmd = [adb_path(), "shell", "am", "force-stop", package_name]
    subprocess.call(cmd)
