from PySide.QtCore import *

import view
import model


class Controller(QObject):
    """Manages interaction between view and model."""

    def __init__(self):
        super(Controller, self).__init__()
        self.view = view.View()
        self.text_provider = model.TextProvider()
        self.view.rootContext().setContextProperty("text_provider",
                                                   self.text_provider)

    def start(self):
        """Start the application."""
        self.view.show()

