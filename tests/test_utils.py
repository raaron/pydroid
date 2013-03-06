import sys
import os
import shutil
import subprocess


def get_local_skeleton_scripts_dir():
    """
    Return the absolute path to the 'scripts' directory in the
    framework/project_skeleton directory.
    """
    pydroid_dir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    return os.path.join(pydroid_dir, 'framework', 'project_skeleton',
                        'scripts')

# Add local scripts of the project_skeleton to the path to import some
sys.path.insert(0, get_local_skeleton_scripts_dir())

from script_utils import reload_local_scripts
from path_utils import adb_path


def reload_local_skeleton_scripts():
    """
    Reload the local scripts if they were already loaded to have the version
    of the local scripts of framework/project_skeleton.
    """
    if 'path_utils' in sys.modules:
        fn = sys.modules['path_utils'].__file__
        old_dir = os.path.dirname(os.path.dirname(fn))
        new_dir = os.path.dirname(get_local_skeleton_scripts_dir())
        reload_local_scripts(old_dir, new_dir)


def remove_directories_if_exist(dirs):
    """Try to remove all directories in dirs."""

    for d in dirs:
        try:
            shutil.rmtree(d)
        except OSError:
            pass


def is_app_running(package_name):
    """Is an app with 'package_name' currently running on the device?"""
    p = subprocess.Popen([adb_path(), 'shell', 'ps'], shell=False,
                         stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output = p.communicate()[0]
    return package_name in output


def is_device_connected():
    """Is there a device recognized by adb?"""

    p = subprocess.Popen([adb_path(), 'devices'], shell=False,
                         stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output = p.communicate()[0]
    return output.split('\n')[1]


def stop_app(package_name):
    """Stop the app with 'package_name on the device.'"""
    cmd = [adb_path(), "shell", "am", "force-stop", package_name]
    subprocess.call(cmd)
