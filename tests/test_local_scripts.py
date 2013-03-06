import unittest
import sys
import os
import subprocess
import ConfigParser

import test_utils

# Add local scripts of the project_skeleton to the path to import some
sys.path.insert(0, test_utils.get_local_skeleton_scripts_dir())

from path_utils import *
import rename
import zip_app
import zip_libs
import add_library
import pydroid_pip_install

# Add global scripts of the project_skeleton to the path to import some
sys.path.insert(0, global_scripts_dir())

import pydroid


APP_NAME = "hello_world"
DOMAIN = 'hello.world'

NEW_APP_NAME = 'new_project_name'
NEW_DOMAIN = 'new.project.name'
RENAMED_PROJECT_DIR = os.path.join(pydroid_dir(), NEW_APP_NAME)


class TestLocalScripts(unittest.TestCase):

    def setUp(self):
        test_utils.reload_local_skeleton_scripts()

        old_project_dir = os.path.join(pydroid_dir(), APP_NAME)

        test_utils.remove_directories_if_exist([old_project_dir,
                                                RENAMED_PROJECT_DIR])

        pydroid.pydroid([APP_NAME, DOMAIN])
        self.assertTrue(os.path.exists(os.path.join(pydroid_dir(), APP_NAME)))
        os.chdir(project_dir())

        self.conf = ConfigParser.ConfigParser()
        self.conf.read(libs_config_file())

    def test_libs_config(self):
        """
        Check whether all libraries are present in the libs.conf
        configuration file.
        """
        libs = [l for l in os.listdir(framework_libs_dir()) if l != 'libs.conf']
        self.assertTrue(sorted(libs), sorted(self.conf.options('libs')))

    def test_add_library_cmd_line(self):
        """Test adding a library to the project from the commandline."""

        lib_name = self.conf.options('libs')[0]
        cmd = [os.path.join(project_dir(), "add_library"), lib_name]
        subprocess.call(cmd)
        self.assertTrue(os.path.exists(os.path.join(project_libs_dir(),
                                                    lib_name)))

    def test_add_library_python_api(self):
        """Test adding a library to the project via python api."""

        lib_name = 'qt_components'
        add_library.add_library([lib_name])
        self.assertTrue(os.path.exists(os.path.join(project_libs_dir(),
                                                    lib_name)))

    def test_rename_cmd_line(self):
        """Test renaming a project from the commandline."""

        cmd = [os.path.join(project_dir(), "rename"), NEW_APP_NAME, NEW_DOMAIN]
        subprocess.call(cmd)
        self.assertTrue(os.path.exists(RENAMED_PROJECT_DIR))

    def test_rename_python_api(self):
        """Test renaming a project via python api."""

        rename.rename([NEW_APP_NAME, NEW_DOMAIN])
        self.assertTrue(os.path.exists(RENAMED_PROJECT_DIR))

    def test_qt_creator_prebuild_script_cmd_line(self):
        """
        Test the prebuild-script for QtCreator, started from commandline.
        APP_DIR and LIBS_DIR should be zipped.
        """
        for d in [app_zip_file(), libs_zip_file()]:
            self.assertFalse(os.path.exists(d))

        cmd = ['python',
               os.path.join(local_scripts_dir(),
                            'qt_creator_prebuild_script.py')]

        subprocess.call(cmd)

        for d in [app_zip_file(), libs_zip_file()]:
            self.assertTrue(os.path.exists(d))

    def test_pydroid_pip_install_cmd_line(self):
        """Test adding a new python package to the project from commandline."""

        module_name = 'simplekv'
        package_dir = os.path.join(site_packages_dir(), module_name)
        self.assertFalse(os.path.exists(package_dir))
        cmd = [os.path.join(project_dir(), "pydroid_pip_install"), module_name]
        subprocess.call(cmd)
        self.assertTrue(os.path.exists(package_dir))

    def test_pydroid_pip_install_python_api(self):
        """Test adding a new python package to the project via python api."""

        module_name = 'simplekv'
        package_dir = os.path.join(site_packages_dir(), module_name)
        self.assertFalse(os.path.exists(package_dir))
        pydroid_pip_install.pydroid_pip_install([module_name])
        self.assertTrue(os.path.exists(package_dir))

    def test_zip_app(self):
        """Test zipping APP_DIR."""

        self.assertFalse(os.path.exists(app_zip_file()))
        zip_app.zip_app()
        self.assertTrue(os.path.exists(app_zip_file()))

    def test_zip_libs(self):
        """Test zipping LIBS_DIR."""

        self.assertFalse(os.path.exists(libs_zip_file()))
        zip_libs.zip_libs()
        self.assertTrue(os.path.exists(libs_zip_file()))


if __name__ == '__main__':
    unittest.main()
