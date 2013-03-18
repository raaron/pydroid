import os

from PySide.QtGui import *
from PySide.QtCore import *


is_on_android = "EXTERNAL_STORAGE" in os.environ


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

    pb = QPushButton("\n\n.         OK         .\n\n")
    msgBox = QMessageBox(flags=Qt.WindowStaysOnTopHint)
    msgBox.setText(str(obj))
    msgBox.setStandardButtons(QMessageBox.NoButton)
    msgBox.addButton(pb, QMessageBox.AcceptRole)
    msgBox.exec_()
