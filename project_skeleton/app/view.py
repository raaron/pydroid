# This file is currently useless, because importing .py files from main.py
# fails. But for the future, it would be nice, to separate the view code from
# the logging and importing setup in main.py.

from PySide.QtDeclarative import *


class View(QDeclarativeView):
    """Main view of the app."""

    def __init__(self, parent=None):
        super(View, self).__init__(parent)
        self.setResizeMode(QDeclarativeView.SizeRootObjectToView)
        self.setSource("view.qml")