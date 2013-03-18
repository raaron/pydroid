# Helpers for scripting.

import sys
import subprocess
import compileall

from path_utils import adb_path, package_name, app_dir


def is_device_rooted():
    """Is the device recognized by adb rooted?"""

    p = subprocess.Popen([adb_path(), 'shell', 'su -c "pwd"'], shell=False,
                         stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    return "not found" not in p.communicate()[0]


def restart_app(show_log=False):
    """
    Restart the app (for rooted devices) or bring the app to the
    front (for non-rooted devices) with the current version.
    Show logcat output if 'show_log' is true.
    """
    if is_device_rooted():
        # Stopping an app is not possible on non-rooted devices

        stop_cmd = [adb_path(), "shell", "am", "force-stop", package_name()]
        subprocess.call(stop_cmd)

    start_cmd = [adb_path(), "shell", "am", "start", "-n",
                 "%s/org.kde.necessitas.origo.QtActivity" % package_name()]

    subprocess.call(start_cmd)

    if show_log:
        log_cmd = [adb_path(), "shell", "logcat"]
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
    return compileall.compile_dir(app_dir(), maxlevels=100, quiet=True)
