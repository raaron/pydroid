import unittest
import sys
import os
import time
import subprocess

import test_utils

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from pydroid import hello_world
from pydroid import create_app
from pydroid.path_utils import *
from pydroid import complete_deploy
from pydroid import fast_deploy


TESTS_DIR = os.path.dirname(os.path.abspath(__file__))
APP_NAME = "hello_world"
DOMAIN = "com.example"
PACKAGE_NAME = "%s.%s" % (DOMAIN, APP_NAME)
PROJECT_DIR = os.path.join(TESTS_DIR, APP_NAME)


class TestHelloWorldDeployScripts(unittest.TestCase):
    """Test cases for 'hello_world.py' scripts."""

    def setUp(self):
        """
        Explicitly remove previous test projects, to be sure a new one is
        created.
        """
        os.chdir(TESTS_DIR)
        test_utils.stop_app(PACKAGE_NAME)
        self.assertFalse(test_utils.is_app_running(PACKAGE_NAME))
        test_utils.remove_directories_if_exist([PROJECT_DIR])
        self.assertFalse(os.path.exists(PROJECT_DIR))

    def tearDown(self):
        self.assertTrue(os.path.exists(PROJECT_DIR))

        # Wait for termination of the app installation before checking
        time.sleep(6)
        self.assertTrue(test_utils.is_app_running(PACKAGE_NAME))
        test_utils.stop_app(PACKAGE_NAME)
        os.chdir(TESTS_DIR)
        test_utils.remove_directories_if_exist([PROJECT_DIR])

    def test_hello_cmd_line(self):
        """
        Test creating, deploying and running a new hello world project
        from the commandline.
        """
        cmd = ['python', os.path.join(pydroid_dir(), "hello_world.py")]
        subprocess.call(cmd)

    def test_hello_python_api(self):
        """
        Test creating, deploying and running a new hello world project
        via python api.
        """
        hello_world.hello_world(show_log=False)


class TestCompleteDeployScripts(unittest.TestCase):
    """Test cases for 'complete_deploy.py' scripts."""

    @classmethod
    def setUpClass(cls):
        """Set up a new project."""
        os.chdir(TESTS_DIR)
        test_utils.stop_app(PACKAGE_NAME)
        test_utils.remove_directories_if_exist([PROJECT_DIR])
        create_app.create_app([APP_NAME, DOMAIN])

    @classmethod
    def tearDownClass(cls):
        """Finally clean up the test project."""

        os.chdir(TESTS_DIR)
        test_utils.remove_directories_if_exist([PROJECT_DIR])

    def setUp(self):
        self.assertFalse(test_utils.is_app_running(PACKAGE_NAME))

    def tearDown(self):
        # Wait for termination of the app installation before checking
        time.sleep(6)
        self.assertTrue(test_utils.is_app_running(PACKAGE_NAME))
        test_utils.stop_app(PACKAGE_NAME)

    def test_complete_deploy_cmd_line(self):
        """Test deploying and running the test project from the commandline."""

        cmd = ['pydroid', 'deploy', 'complete']
        subprocess.call(cmd)

    def test_complete_deploy_python_api(self):
        """
        Test creating, deploying and running a new hello world project
        via python api.
        """
        complete_deploy.complete_deploy(show_log=False)


class TestFastDeployScript(unittest.TestCase):
    """Test cases for fast_deploy.py script."""

    @classmethod
    def setUpClass(cls):
        """Create a new test project and install and run it properly."""

        os.chdir(TESTS_DIR)
        test_utils.stop_app(PACKAGE_NAME)
        hello_world.hello_world(show_log=False)

        # Wait for termination of the app installation before doing fast deploys.
        time.sleep(6)
        test_utils.stop_app(PACKAGE_NAME)

    @classmethod
    def tearDownClass(cls):
        """Clean up the test project."""

        test_utils.remove_directories_if_exist([PROJECT_DIR])

    def setUp(self):
        self.assertFalse(test_utils.is_app_running(PACKAGE_NAME))

    def tearDown(self):

        # Wait until the app was started successful
        time.sleep(6)

        self.assertTrue(test_utils.is_app_running(PACKAGE_NAME))
        test_utils.stop_app(PACKAGE_NAME)

    def test_fast_deploy_cmd_line(self):
        """Test the fast deployment method from command line."""

        cmd = ['pydroid', 'deploy', 'fast']
        subprocess.call(cmd)

    def test_fast_deploy_python_api(self):
        """Test the fast deployment method via python api."""

        fast_deploy.fast_deploy(show_log=False)


if __name__ == '__main__':
    unittest.main()
