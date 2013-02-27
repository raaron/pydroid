from PySide.QtDeclarative import *


class View(QDeclarativeView):
    """Main view of the app."""

    def __init__(self, parent=None):
        super(View, self).__init__(parent)
        self.setResizeMode(QDeclarativeView.SizeRootObjectToView)
        self.setSource("view.qml")
