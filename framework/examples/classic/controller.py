from PySide.QtCore import *

import view
import model


class Controller(QObject):
    """Manages interaction between view and model."""

    def __init__(self):
        super(Controller, self).__init__()
        self.person = model.Person(name="Chuck Norris", age=73, weight=80)
        self.view = view.View(self.person)
        self.view.pb_eat.clicked.connect(self.on_eat)

    def start(self):
        """Start the application."""

        self.view.show()

    def on_eat(self):
        """Slot to be called if a person has eaten something."""

        self.person.eat()
        self.view.update_label_weight()

