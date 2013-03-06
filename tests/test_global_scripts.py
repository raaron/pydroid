import unittest
import sys
import os
import shutil
import subprocess

import test_utils

# Add local scripts of the project_skeleton to the path to import some
sys.path.insert(0, test_utils.get_local_skeleton_scripts_dir())

from path_utils import pydroid_dir, global_scripts_dir

# Add global scripts of the project_skeleton to the path to import some
sys.path.insert(0, global_scripts_dir())

import create_example
import pydroid


APP_NAME = "hello_world"
DOMAIN = 'hello.world'
EXAMPLE_PROJECT_DIR = os.path.join(pydroid_dir(),
                                   '%s%s' % (APP_NAME,
                                             create_example.APP_NAME_SUFFIX))

NEW_PROJECT_DIR = os.path.join(pydroid_dir(), APP_NAME)


class TestGlobalScripts(unittest.TestCase):

    def setUp(self):
        test_utils.reload_local_skeleton_scripts()

        for d in [EXAMPLE_PROJECT_DIR, NEW_PROJECT_DIR]:
            try:
                shutil.rmtree(d)
            except OSError:
                pass

    def test_create_example_cmd_line(self):
        """Test creating example projects from the commandline."""

        self.assertFalse(os.path.exists(EXAMPLE_PROJECT_DIR))
        cmd = [os.path.join(pydroid_dir(), "create_example"), APP_NAME]
        subprocess.call(cmd)
        self.assertTrue(os.path.exists(EXAMPLE_PROJECT_DIR))

    def test_create_example_python_api(self):
        """Test creating example projects via python api."""

        self.assertFalse(os.path.exists(EXAMPLE_PROJECT_DIR))
        create_example.create_example([APP_NAME])
        self.assertTrue(os.path.exists(EXAMPLE_PROJECT_DIR))

    def test_pydroid_cmd_line(self):
        """Test creating a new project from the commandline."""

        self.assertFalse(os.path.exists(NEW_PROJECT_DIR))
        cmd = [os.path.join(pydroid_dir(), "pydroid"), APP_NAME, DOMAIN]
        subprocess.call(cmd)
        self.assertTrue(os.path.exists(NEW_PROJECT_DIR))

    def test_pydroid_python_api(self):
        """Test creating a new project via python api."""

        self.assertFalse(os.path.exists(NEW_PROJECT_DIR))
        pydroid.pydroid([APP_NAME, DOMAIN])
        self.assertTrue(os.path.exists(NEW_PROJECT_DIR))


if __name__ == '__main__':
    unittest.main()
