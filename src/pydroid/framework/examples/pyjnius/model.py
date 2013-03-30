from jnius import autoclass
from PySide.QtCore import *

TEXT = """Pyjnius Example

Shows accessing Java classes using pyjnius.

Check the file app/model.py to get
a code example.
"""


class DataProvider(QObject):
    """Provides the GUI with some welcome text, and data accessed via pyjnius.
    """

    @Slot(result=str)
    def get_text(self):
        """Return the text for the GUI."""

        return TEXT

    @Slot(result=str)
    def get_sensor_data(self):
        """Return a string with sensor data."""

        # Accessing our own classes still fails, so use some stdlib classes
        # for the moment.
        Stack = autoclass('java.util.Stack')
        stack = Stack()
        return "Classname of the java 'Stack' class:\n%s" % stack.getClass().getName()


if __name__ == '__main__':
    dp = DataProvider()
    print dp.get_text()
