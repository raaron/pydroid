#!/usr/bin/python

# Collect and pretty print information (paths, size, etc.) about this project.

from path_utils import *


SEPARATOR = '\n%s\n' % ('-' * 79)


class StatusReport(object):
    """Stores information of a status report of a project."""

    def __init__(self):
        self.important_project_paths = self.get_important_project_paths()
        self.important_build_paths = self.get_important_build_paths()
        self.important_device_paths = self.get_important_device_paths()
        self.uncompressed_size = self.get_uncompressed_size()
        self.uses_qml = "TODO"
        self.uses_qt_components = 'qt_components' in os.listdir(project_libs_dir())
        self.app_name = app_name()
        self.package_name = package_name()
        self.arm_version = arm_version()
        self.dependencies = "TODO"
        self.was_deployed = os.path.exists(apk_file())
        if self.was_deployed:
            self.apk_size = os.path.getsize(apk_file())
        else:
            self.apk_size = 0

    def get_important_project_paths(self):
        """Returns a dict containing all important project paths."""

        return {'pydroid directory': pydroid_dir(),
                'project directory': project_dir(),
                'build configuration file': build_config_file(),
                'apk file': apk_file(),
                'libraries directory': project_libs_dir(),
                'app directory': app_dir(),
                'main python file': main_python_file()}

    def get_important_build_paths(self):
        """Returns a dict containing all important build paths."""

        return {'adb path': adb_path(),
                'necessitas directory': necessitas_dir(),
                'necessitas qmake path': necessitas_qmake_path()}

    def get_important_device_paths(self):
        """Returns a dict containing all important device paths."""

        return {'sdcard directory': device_sdcard_dir(),
                'device app directory': device_app_dir(),
                'device libs directory': device_libs_dir()}

    def get_uncompressed_size(self):
        """
        Return the estimated size of the decompressed project on
        the device.
        """
        app_dir_size = self.get_directory_size(app_dir())
        libs_dir_size = self.get_directory_size(project_libs_dir())

        excluded = [android_bin_dir(), android_gen_dir(),
                    android_res_raw_dir()]

        android_dir_size = self.get_directory_size(android_dir(), excluded)
        return app_dir_size + libs_dir_size + android_dir_size

    def get_directory_size(self, dirname, excluded_path_prefixes=[]):
        """
        Return the size of a directory with all its subdirectories, but
        ignore any file whichs path starts with one of the paths in
        'excluded_path_prefixes'.
        """
        total_size = 0
        for dirpath, dirnames, filenames in os.walk(dirname):
            for f in filenames:
                fp = os.path.join(dirpath, f)

                # Evaluate whether this file should be ignored or not
                excluded = False
                for excluded_path_prefix in excluded_path_prefixes:
                    if os.path.abspath(fp).startswith(excluded_path_prefix):
                        excluded = True
                        break

                if not excluded:
                    total_size += os.path.getsize(fp)

        return total_size

    def get_directory_pretty_print(self, d):
        """Return a two column table of keys and values of directory 'd'."""

        strs = ["%-30s %s" % (key, value) for key, value in d.iteritems()]
        return '\n'.join(strs)

    def __repr__(self):
        general_settings = """
General settings:
-----------------
App name:                      %s
Package name:                  %s
Already deployed:              %s
Uses QML:                      %s
Uses qt_components:            %s
Dependencies:                  %s
""" % (self.app_name, self.package_name, self.was_deployed, self.uses_qml,
       self.uses_qt_components, self.dependencies)

        pretty_size = """
Size:
-----
APK:                           %s
Uncompressed app:              %d MB
""" % (str(self.apk_size / 10**6) + ' MB' if self.was_deployed else "Does not exist yet.",
       self.uncompressed_size / 10**6)

        pretty_paths = """
Important project paths:
------------------------
%s

Important build paths:
----------------------
%s

Important device paths:
-----------------------
%s
""" % (self.get_directory_pretty_print(self.important_project_paths),
       self.get_directory_pretty_print(self.important_build_paths),
       self.get_directory_pretty_print(self.important_device_paths))

        output = """
Project information and status
==============================

%s
%s
%s
""" % (general_settings, pretty_size, pretty_paths)

        return output


def status():
    """
    Pretty print and return information about this project.
    """
    report = StatusReport()
    return report


if __name__ == '__main__':
    print status()
