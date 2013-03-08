from PySide.QtCore import *

import view


class Controller(QObject):
    """Manages interaction between view and model."""

    def __init__(self):
        super(Controller, self).__init__()
        self.view = view.View()

    def start(self):
        """Start the application."""
        self.view.show()

