#!/usr/bin/env python

from PyQt4 import QtCore, QtGui, QtDeclarative

class TodoItem(QtCore.QObject):
    """
    Class representing the Python Backend for an item in a list. Signals are connected to the
    button represented in the QML file relative to this item and processing of the signal to
    edit the item's text is also implemented here.
    """
    contentChanged = QtCore.pyqtSignal()
    
    def __init__(self):
        super(TodoItem, self).__init__()

        self._item_text = ''

    @QtCore.pyqtProperty(QtCore.QString, notify=contentChanged)
    def item_text(self):
        """
        Editing content of an item.
        """
        return self._item_text

    def set_text(self, txt):
        """
        Signal emitted when edit button is clicked.
        """
        if self._item_text != txt:
            self._item_text = txt
            self.contentChanged.emit()
