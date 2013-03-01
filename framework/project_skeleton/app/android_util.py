import os
from ctypes import *


is_on_android = "EXTERNAL_STORAGE" in os.environ


def load_shiboken_and_pyside():
    """
    PySide bindings can't find the libshiboken.so and libshiboken.so.
    Load them manually to memory with ctypes before any PySide import.
    """
    # PYSIDE_APPLICATION_FOLDER is set in main.h in the Example project
    PROJECT_FOLDER = os.environ['PYSIDE_APPLICATION_FOLDER']
    LIB_DIR = os.path.join(PROJECT_FOLDER, 'files/python/lib')
    CDLL(os.path.join(LIB_DIR, 'libshiboken.so'))
    CDLL(os.path.join(LIB_DIR, 'libpyside.so'))


def log(obj):
    """
    Write the string representation of the object 'obj' to the circular
    android log buffer at /dev/log/main.
    With priority INFO and tag 'pydroid'
    """
    with file("/dev/log/main", 'a') as fobj:
        fobj.write("%spydroid\0%s\0" % (chr(4), str(obj)))


def logv(obj):
    """Show a message box with the string representation of the object 'obj'"""

    from PySide.QtGui import *
    from PySide.QtCore import *

    pb = QPushButton("\n\n.         OK         .\n\n")
    msgBox = QMessageBox(flags=Qt.WindowStaysOnTopHint)
    msgBox.setText(str(obj))
    msgBox.setStandardButtons(QMessageBox.NoButton)
    msgBox.addButton(pb, QMessageBox.AcceptRole)
    msgBox.exec_()
