# Helpers for scripting.

import sys
import os
import subprocess
import compileall

from path_utils import adb_path, package_name, app_dir


def restart_app(show_log=False):
    """
    Restart the app with the current version.
    Show logcat output if 'show_log' is true.
    """
    stop_cmd = [adb_path(), "shell", "am", "force-stop", package_name()]
    start_cmd = [adb_path(), "shell", "am", "start", "-n",
                 "%s/org.kde.necessitas.origo.QtActivity" % package_name()]

    subprocess.call(stop_cmd)
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


def reload_local_scripts(old_project_dir, new_project_dir):
    """
    Reloads the local scripts of 'new_project_dir' instead of the already
    loaded local scripts of 'old_project_dir'.
    """
    __replace_sys_path(old_project_dir, new_project_dir)
    __reload_sys_modules(new_project_dir)


def __replace_sys_path(old_project_dir, new_project_dir):
    """
    Replaces the prefix of all paths in sys.path beginning with
    'old_project_dir' by 'new_project_dir'.
    """
    for i in xrange(len(sys.path)):
        if sys.path[i].startswith(old_project_dir):
            sys.path[i] = sys.path[i].replace(old_project_dir, new_project_dir)


def __reload_sys_modules(new_project_dir):
    """Tries to reload all loaded local scripts in sys.modules."""

    new_local_scripts_dir = os.path.join(new_project_dir, 'scripts')
    to_reload = set([n.split('.')[0] for n in os.listdir(new_local_scripts_dir)])

    for name, module in sys.modules.iteritems():
        if name in to_reload:
            try:
                reload(module)
            except:
                pass
