#!/usr/bin/python

# Checks your system for the required dependencies and paths.

import os
import subprocess

from path_utils import *


SEPARATOR = '\n%s\n' % ('-' * 79)
ADB_PATH_PLACEHOLDER = "/PATH/TO/ADB"
NECESSITAS_DIR_PLACEHOLDER = "/PATH/TO/NECESSITAS"
ARM_VERSION_PLACEHOLDER = "ARM-VERSION"


class Error(object):
    """Error description and proposition of a fix for a failed check."""

    def __init__(self, problem, fix):
        self.problem = problem
        self.fix = fix

    def __repr__(self):
        """Return a pretty print version of the error."""

        return """
Problem:
--------
%s

Fix:
----
%s
""" % (self.problem, self.fix)


class Success(object):
    """Message about a successful check."""

    def __init__(self, description):
        self.description = description

    def __repr__(self):
        return "%-40s Success" % self.description


def check_pydroid_directory_structure(errors, successes):
    """
    Check whether all importand directories and files are at their place.
    Returns true if the check is successful.
    """
    problem = "The following pydroid directory should exist, but doesn't:\n%s"
    git_url = "https://github.com/raaron/pydroid.git"
    fix = "Two options:\n"\
          "\t* Add the missing component manually\n"\
          "\t* Backup your projects, delete the entire pydroid directory and perform"\
          "a fresh:\n"\
          "\t\tgit clone %s" % git_url

    ps = [framework_dir, skeleton_dir, examples_dir, examples_config_file,
          framework_libs_dir, project_dir, qtcreator_config_file,
          naming_config_file, android_dir, android_res_raw_dir,
          project_libs_dir, python27_dir, pydroid_dir, libs_config_file]

    successful = True
    for p in ps:
        if not os.path.exists(p()):
            successful = False
            errors.append(Error(problem % p(), fix))

    if successful:
        successes.append(Success("Pydroid directory structure"))
    return successful


def check_project_configuration(errors, successes):
    """
    Check if the configuration file 'project.conf' has been modified where
    required.
    Returns true if the check is successful.
    """
    successful = True
    problem = "The following configuration value in 'project.conf' has not already been\n"\
              "adapted to your system:\n\t'%s'"
    fix = "Edit the file YOUR_PROJECT_DIR/project.conf according to your system."
    if adb_path() == ADB_PATH_PLACEHOLDER:
        errors.append(Error(problem % 'adb_path', fix))
        successful = False
    if necessitas_dir() == NECESSITAS_DIR_PLACEHOLDER:
        errors.append(Error(problem % 'necessitas_dir', fix))
        successful = False
    if arm_version() == ARM_VERSION_PLACEHOLDER:
        errors.append(Error(problem % 'arm_version', fix))
        successful = False

    if successful:
        successes.append(Success("Project configuration"))
    return successful


def check_necessitas_directories_and_tools(errors, successes):
    """
    Check the necessitas directory structure and
    existance of adb and qmake.
    Returns true if the check is successful.
    """
    problem = "The following necessitas directory should exist, but doesn't:\n%s"
    installer_url = "http://necessitas.kde.org/necessitas/necessitas_sdk_installer.php"
    fix = "Two options:\n"\
          "\t* Add the missing component manually\n"\
          "\t* Reinstall necessitas using the installer from the following url:\n"\
          "\t\t%s" % installer_url

    ps = [adb_path, necessitas_dir, necessitas_sdk_dir, build_config_file,
          necessitas_android_qt_482_dir, necessitas_qmake_path,
          necessitas_qtcreator_qt_dir, necessitas_qtcreator_qt_plugin_dir]

    successful = True
    for p in ps:
        if not os.path.exists(p()):
            successful = False
            errors.append(Error(problem % p(), fix))

    if successful:
        successes.append(Success("Necessitas directory structure"))
    return successful


def is_device_connected():
    """Is there a device recognized by adb?"""

    p = subprocess.Popen([adb_path(), 'devices'], shell=False,
                         stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output = p.communicate()[0]
    return output.split('\n')[1] != ""


def is_device_rooted():
    """Is the rooted device recognized by adb rooted?"""

    p = subprocess.Popen([adb_path(), 'shell', 'su -c "pwd"'], shell=False,
                         stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return "not found" not in p.communicate()[0]


def check_device_connected(errors, successes):
    """
    Check if a Android device can be recognized by adb.
    If so, return true.
    """
    if is_device_connected():
        successes.append(Success("Recognize connected Android device"))
        return True
    else:
        fix = "* Plug in your device. If it is already plugged in, remove it and reconnect it.\n"\
              "* Enable USB-debugging on your device:\n"\
                "\t* Android version < 4.0: Settings > Applications > Development > USB-Debugging\n"\
                "\t* Android version >= 4.0: Settings > Developer options > USB-Debugging\n\n"\
              "* If you are on a virtual machine:\n"\
                "\t* Install the guest addition\n"\
                "\t* In virtualbox main window: Select machine > Settings > USB > Add-Icon > Select device\n"\
                "\t* In case you can't see any device listed and you have a Ubuntu host system:\n"\
                    "\t\t* Install gnome-system-tools: 'sudo apt-get install gnome-system-tools'\n"\
                    "\t\t* In terminal: 'users-admin'\n"\
                    "\t\t* Advanced settings > User Privileges > Use Virtualbox virtualization solution > OK\n"\
                    "\t\t* Log out, then log in again\n"\
                    "\t\t* Now you should see the devices: Select machine > Settings > USB > Add-Icon > Select device"

        errors.append(Error("No device found.", fix))
        return False


def check_device_rooted(errors, successes):
    """
    Check if the recognized Android device is rooted.
    If so, return true.
    """
    if is_device_rooted():
        successes.append(Success("Android device is rooted"))
        return True
    else:
        problem = "Your device is not rooted. The following scripts will not work:\n\t./fast_deploy\n\t./hello."
        fix = "IMPORTANT NOTE: Rooting the device will destroy your warranty on the device!\n"\
              "Rooting the device is device specific. Search on Google for \n"\
              "'android root MY_DEVICE_TYPE' to find\n"\
              "an online tutorial about how to root your device.\n"
        errors.append(Error(problem, fix))
        return False


def check_system():
    """
    Check the pydroid installation and pydroids dependencies. In case of
    errors, report them, otherwise show a summary of successful checks.
    Returns a tuple of (errors, successes)
    """
    print "\nChecking your system, this may take a few seconds..."
    errors = []
    successes = []
    check_pydroid_directory_structure(errors, successes)
    if check_project_configuration(errors, successes):
        check_necessitas_directories_and_tools(errors, successes)
    check_device_connected(errors, successes)
    check_device_rooted(errors, successes)
    print SEPARATOR.join([str(e) for e in errors])

    if not errors:
        for s in successes:
            print s
    print

    return (errors, successes)


if __name__ == '__main__':
    check_system()
