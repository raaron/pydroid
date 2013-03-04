import unittest
import sys
import os
import shutil
import subprocess

TEST_DIR = os.path.dirname(os.path.realpath(__file__))
PYDROID_DIR = os.path.dirname(TEST_DIR)
APP_NAME = "hello_world"
DOMAIN = 'hello.world'
EXAMPLE_PROJECT_DIR = os.path.join(PYDROID_DIR, '%s_example' % APP_NAME)
NEW_PROJECT_DIR = os.path.join(PYDROID_DIR, APP_NAME)


sys.path.append(os.path.join(PYDROID_DIR, 'scripts'))

import create_example
import pydroid
# import hello_world


class TestGlobalScripts(unittest.TestCase):

    def setUp(cls):
        for d in [EXAMPLE_PROJECT_DIR, NEW_PROJECT_DIR]:
            try:
                shutil.rmtree(d)
            except OSError:
                pass
        os.chdir(PYDROID_DIR)

    def test_create_example_cmd_line(self):
        """Test creating example projects from the commandline."""

        self.assertFalse(os.path.exists(EXAMPLE_PROJECT_DIR))
        cmd = [os.path.join(PYDROID_DIR, "create_example"), APP_NAME]
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
        cmd = [os.path.join(PYDROID_DIR, "pydroid"), APP_NAME, DOMAIN]
        subprocess.call(cmd)
        self.assertTrue(os.path.exists(NEW_PROJECT_DIR))

    def test_pydroid_python_api(self):
        """Test creating a new project via python api."""

        self.assertFalse(os.path.exists(NEW_PROJECT_DIR))
        pydroid.pydroid([APP_NAME, DOMAIN])
        self.assertTrue(os.path.exists(NEW_PROJECT_DIR))

    # def test_hello_cmd_line(self):
    #     """Test creating a new project from the commandline."""

    #     self.assertFalse(os.path.exists(NEW_PROJECT_DIR))
    #     cmd = [os.path.join(PYDROID_DIR, "hello")]
    #     subprocess.call(cmd)
    #     self.assertTrue(os.path.exists(NEW_PROJECT_DIR))

    # def test_hello_python_api(self):
    #     """Test creating a new project via python api."""

    #     self.assertFalse(os.path.exists(NEW_PROJECT_DIR))
    #     hello_world.hello_world()
    #     self.assertTrue(os.path.exists(NEW_PROJECT_DIR))



if __name__ == '__main__':
    unittest.main()