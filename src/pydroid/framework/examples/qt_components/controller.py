from PySide.QtCore import *

import view
import model


class Controller(QObject):
    """Manages interaction between view and model."""

    def __init__(self):
        super(Controller, self).__init__()
        self.view = view.View()
        self.date_provider = model.DateProvider()
        self.view.rootContext().setContextProperty("date_provider",
                                                   self.date_provider)

    def start(self):
        """Start the application."""
        self.view.show()

