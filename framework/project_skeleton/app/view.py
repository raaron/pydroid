from PySide.QtDeclarative import *


class View(QDeclarativeView):
    """Main view of the app."""

    def __init__(self, parent=None):
        super(View, self).__init__(parent)
        self.setResizeMode(QDeclarativeView.SizeRootObjectToView)
        self.setSource("view.qml")


# class View(QWidget):
#     """Main view of the app."""

#     def __init__(self, parent=None):
#         super(View, self).__init__(parent)
#         self.counter = 0
#         hl = QHBoxLayout(self)
#         l = QVBoxLayout()
#         hl.addLayout(l)
#         hl.addStretch()
#         pb = QPushButton("asdf")
#         le = QLineEdit()
#         self.lb = QLabel(str(self.counter))
#         l.addWidget(pb)
#         l.addWidget(le)
#         l.addWidget(self.lb)
#         pb.clicked.connect(self.onPb)

#     def onPb(self):
#         self.counter += 1
#         self.lb.setText(str(self.counter))
#         logv(self.lb)
