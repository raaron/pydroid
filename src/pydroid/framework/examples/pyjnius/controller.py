from PySide.QtCore import *

import view
import model


class Controller(QObject):
    """Manages interaction between view and model."""

    def __init__(self):
        super(Controller, self).__init__()
        self.view = view.View()
        self.data_provider = model.DataProvider()
        self.view.rootContext().setContextProperty("data_provider",
                                                   self.data_provider)

    def start(self):
        """Start the application."""

        self.view.show()

