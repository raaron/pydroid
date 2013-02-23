#!/usr/bin/env python

# A simple PySide example

import sys
import os
import traceback
import datetime

is_on_android = "EXTERNAL_STORAGE" in os.environ

if is_on_android:

    # for some reason, the PySide bindings can't find the libshiboken.so and libshiboken,
    # even though they are in a directory in LD_LIBRARY_PATH, resulting in errors like this:
    #
    # ImportError: Cannot load library: link_image[1965]:   157 could not load needed library
    # 'libshiboken.so' for 'QtCore.so' (load_library[1120]: Library 'libshiboken.so' not found)
    #
    # if both are loaded to memory manually with ctypes, everything works fine
    from ctypes import *

    # PYSIDE_APPLICATION_FOLDER is set in main.h in the Example project
    PROJECT_FOLDER = os.environ['PYSIDE_APPLICATION_FOLDER']
    LIB_DIR = os.path.join(PROJECT_FOLDER, 'files/python/lib')
    CDLL(os.path.join(LIB_DIR, 'libshiboken.so'))
    CDLL(os.path.join(LIB_DIR, 'libpyside.so'))


from PySide.QtCore import *
from PySide.QtGui import *
from PySide.QtDeclarative import *


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
    Start the app. If we are on an android device, setup the logging first.
    """
    if is_on_android:
        # log to file on Android

        LOG_FOLDER = '/sdcard/'
        fSock = open(os.path.join(LOG_FOLDER, 'pyside_example_log.txt'), 'w', 1)
        rfSock = open(os.path.join(LOG_FOLDER, 'pyside_example_error_log.txt'), 'w', 1)
        sys.stdout = fSock
        sys.stderr = rfSock

        print("** stdout diverted to file **")

        # enable running this program from absolute path
        os.chdir(os.path.dirname(os.path.abspath(__file__)))
        print("dir changed")

        fSock.flush()
        try:
            run_app()
        except Exception:
            fp = open(os.path.join(LOG_FOLDER, 'pyside_example_exception_log.txt'), 'w', 0)
            traceback.print_exc(file=fp)
            fp.flush()
            fp.close()
            traceback.print_exc(file=fSock)
            fSock.flush()
        rfSock.flush()
        rfSock.close()
        fSock.flush()
        fSock.close()
        exit(0)

    else:
        run_app()


if __name__ == '__main__':
    main()