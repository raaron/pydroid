#!/usr/bin/env python

# A simple PySide example

import sys
import os
import traceback

from PySide.QtGui import *
from PySide.QtDeclarative import *

import android_util


APP_DIR = os.path.dirname(os.path.abspath(__file__))


def run_app():
    """Start and show the app."""

    app = QApplication(sys.argv)
    view = QDeclarativeView()
    view.setResizeMode(QDeclarativeView.SizeRootObjectToView)
    view.setSource("view.qml")
    view.show()
    app.exec_()


def main():
    """
    Start the app.
    If we are on an android device, setup the logging first.
    """
    os.chdir(APP_DIR)
    if android_util.is_on_android:
        log_file = os.path.join(os.environ['LOG_DIR'], 'python_log.txt')

        # Redirect stdout and stderr to a file on /sdcard/
        with open(log_file, 'w', 1) as fSock:
            sys.stdout = fSock
            sys.stderr = fSock
            try:
                run_app()
            except Exception:
                traceback.print_exc(file=fSock)
        exit(0)

    else:
        run_app()


if __name__ == '__main__':
    main()
