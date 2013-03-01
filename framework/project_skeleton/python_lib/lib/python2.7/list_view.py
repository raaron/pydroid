#!/usr/bin/env python

from PyQt4 import QtCore, QtGui, QtDeclarative
from PyQt4.QtSql import *
from list_item import *

class ListView(QtCore.QObject):
    """
    This class represents the ListView widget, included are, the database access to retrieve items of
    the list saved in a previous state, adding / deleting / editing of current list items is also
    linked to the database in this class. Signals for adding new item button and the logic on how 
    to process the signal is also implemented.
    """
    itemsChanged = QtCore.pyqtSignal()

    def __init__(self, new_rc, connection):
        super(ListView, self).__init__()

        self._items = []
        self._rc = new_rc
        self._con = connection
        with self._con:
            self._cur = self._con.cursor()
            self._cur.execute("CREATE TABLE IF NOT EXISTS Items(Item TEXT)")
            
        self._cur.execute("SELECT * from Items")        
        row = self._cur.fetchall()        
        for r in row:
            t = TodoItem()
            t.set_text(QtCore.QString(r[0]))
            self._items.insert(0,t)
            
            
    @QtCore.pyqtProperty(QtDeclarative.QPyDeclarativeListProperty, notify=itemsChanged)
    def items(self):
        """
        Loading list contents to the GUI Application.
        """
        return QtDeclarative.QPyDeclarativeListProperty(self, self._items)

    @QtCore.pyqtSlot(QtCore.QString) 
    def add_item(self, txt): 
        """
        Adding a new item to the list.
        """    
        self._cur.execute("INSERT INTO Items VALUES(?)", [str(txt)])
        self._con.commit()
        t = TodoItem()
        t.set_text(QtCore.QString(txt))
        self._items.insert(0, t)
        self._rc.setContextProperty("items", self._items)                
        self.itemsChanged.emit()
        
    @QtCore.pyqtSlot(int)        
    def remove_item(self, to_remove):
        """
        Removing an new item from the list.
        """    
        self._cur.execute("DELETE FROM Items WHERE Item = ?", [str(self._items[to_remove]._item_text)])
        self._con.commit()
        self._items.pop(to_remove)
        self._rc.setContextProperty("items", self._items)
        self.itemsChanged.emit()
        
    @QtCore.pyqtSlot(int, QtCore.QString)        
    def edit_item(self, to_edit, text):
        """
        Editing an new item on the list.
        """
        self._items[to_edit].set_text(text)
        self._rc.setContextProperty("items", self._items)                
        self.itemsChanged.emit()
