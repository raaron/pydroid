# Constants and helpers for scripting.

import sys
import os
import subprocess
import compileall
import ConfigParser

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
APP_DIR = os.path.join(PROJECT_DIR, 'app')
LIBS_DIR = os.path.join(PROJECT_DIR, 'libs')
PYTHON27_DIR = os.path.join(LIBS_DIR, 'python27')
COMPILING_CONFIG_FILE = os.path.join(PROJECT_DIR, "project.conf")
NAMING_CONFIG_FILE = os.path.join(PROJECT_DIR, ".naming.conf")


def get_app_name():
    return __get_from_config("General", "app_name", NAMING_CONFIG_FILE)


def get_package_name():
    return __get_from_config("General", "package_name", NAMING_CONFIG_FILE)


def get_adb_path():
    return __get_from_config("Compiling", "adb_path", COMPILING_CONFIG_FILE)


def get_arm_version():
    return __get_from_config("Compiling", "arm_version", COMPILING_CONFIG_FILE)


def get_necessitas_dir():
    return __get_from_config("Compiling", "necessitas_dir",
                             COMPILING_CONFIG_FILE)


def restart_app(show_log=False):
    """
    Restart the app with the current version.
    Show logcat output if 'show_log' is true.
    """
    stop_cmd = [get_adb_path(), "shell", "am", "force-stop", get_package_name()]
    start_cmd = [get_adb_path(), "shell", "am", "start", "-n",
                 "%s/org.kde.necessitas.origo.QtActivity" % get_package_name()]

    subprocess.call(stop_cmd)
    subprocess.call(start_cmd)
    if show_log:
        log_cmd = [get_adb_path(), "shell", "logcat"]
        clear_log_cmd = log_cmd + ["-c"]
        try:
            subprocess.call(clear_log_cmd)
            subprocess.call(log_cmd)
        except KeyboardInterrupt:
            sys.exit(0)


def compile_app_directory():
    """
    Bytecompile all python source files located in APP_DIR.
    Returns 1 if there were no errors, otherwise 0.
    """
    return compileall.compile_dir(APP_DIR, maxlevels=100, quiet=True)


def __get_from_config(section, name, config_file):
    """Return this entry from the config file."""

    conf = ConfigParser.ConfigParser()
    conf.read(config_file)
    return conf.get(section, name)
