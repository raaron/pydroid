import datetime

from PySide.QtCore import *


class DateProvider(QObject):
    """Provides the GUI the current date-time."""

    @Slot(result=str)
    def get_date(self):
        """Return current date & time."""
        return str(datetime.datetime.now())


if __name__ == '__main__':
    dp = DateProvider()
    print dp.getDate()
