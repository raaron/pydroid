#!/usr/bin/env python

# A simple PySide example

import sys
import os
import traceback

import android_util

# Load libshiboken and libpyside before doing PySide imports on Android
if android_util.is_on_android:
    android_util.load_shiboken_and_pyside()

from PySide.QtCore import *
from PySide.QtGui import *
from PySide.QtDeclarative import *

import controller


APP_DIR = os.path.dirname(os.path.abspath(__file__))
LOG_DIR = '/sdcard/'
STDOUT_PATH = os.path.join(LOG_DIR, 'pyside_example_log.txt')
STDERR_PATH = os.path.join(LOG_DIR, 'pyside_example_error_log.txt')


def run_app():
    """Start and show the app."""

    app = QApplication(sys.argv)
    c = controller.Controller()
    c.start()
    app.exec_()


def main():
    """
    Start the app.
    If we are on an android device, setup the logging first.
    """
    os.chdir(APP_DIR)
    if android_util.is_on_android:

        # Redirect stdout and stderr to files on /sdcard/
        with open(STDOUT_PATH, 'w', 1) as fSock:
            with open(STDERR_PATH, 'w', 1) as rfSock:
                sys.stdout = fSock
                sys.stderr = rfSock
                try:
                    run_app()
                except Exception:
                    traceback.print_exc(file=fSock)
                    traceback.print_exc(file=rfSock)
        exit(0)

    else:
        run_app()


if __name__ == '__main__':
    main()
