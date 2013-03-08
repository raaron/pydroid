import unittest
import sys
import os
import subprocess

import test_utils

sys.path.insert(0, os.pardir)

from pydroid import create_example
from pydroid import create_app

TESTS_DIR = os.path.dirname(os.path.abspath(__file__))
APP_NAME = "hello_world"
DOMAIN = 'hello.world'
EXAMPLE_PROJECT_DIR = os.path.join(TESTS_DIR,
                                   '%s%s' % (APP_NAME,
                                             create_example.APP_NAME_SUFFIX))

NEW_PROJECT_DIR = os.path.join(TESTS_DIR, APP_NAME)


class TestGlobalScripts(unittest.TestCase):

    def setUp(self):
        os.chdir(TESTS_DIR)
        test_utils.remove_directories_if_exist([EXAMPLE_PROJECT_DIR,
                                                NEW_PROJECT_DIR])

    @classmethod
    def tearDownClass(cls):
        test_utils.remove_directories_if_exist([EXAMPLE_PROJECT_DIR,
                                                NEW_PROJECT_DIR])

    def test_create_example_cmd_line(self):
        """Test creating example projects from the commandline."""

        self.assertFalse(os.path.exists(EXAMPLE_PROJECT_DIR))
        cmd = ['pydroid', 'create', 'example', APP_NAME]
        subprocess.call(cmd)
        self.assertTrue(os.path.exists(EXAMPLE_PROJECT_DIR))

    def test_create_example_python_api(self):
        """Test creating example projects via python api."""

        self.assertFalse(os.path.exists(EXAMPLE_PROJECT_DIR))
        create_example.create_example([APP_NAME])
        self.assertTrue(os.path.exists(EXAMPLE_PROJECT_DIR))

    def test_create_app_cmd_line(self):
        """Test creating a new project from the commandline."""

        self.assertFalse(os.path.exists(NEW_PROJECT_DIR))
        cmd = ['pydroid', 'create', 'app', 'name:%s' % APP_NAME,
               'domain:%s' % DOMAIN]

        subprocess.call(cmd)
        self.assertTrue(os.path.exists(NEW_PROJECT_DIR))

    def test_create_app_python_api(self):
        """Test creating a new project via python api."""

        self.assertFalse(os.path.exists(NEW_PROJECT_DIR))
        create_app.create_app([APP_NAME, DOMAIN])
        self.assertTrue(os.path.exists(NEW_PROJECT_DIR))


if __name__ == '__main__':
    unittest.main()
