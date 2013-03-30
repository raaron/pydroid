from PySide.QtCore import *


TEXT = """Hello world example

Edit the following files:

    app/
        - controller.py
        - model.py
        - view.py
        - view.qml"""


class TextProvider(QObject):
    """Provides the GUI with some welcome text and instruction."""

    @Slot(result=str)
    def get_text(self):
        """Return the text for the GUI."""

        return TEXT


if __name__ == '__main__':
    tp = TextProvider()
    print tp.get_text()
