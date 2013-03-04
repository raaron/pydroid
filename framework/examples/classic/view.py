from PySide.QtGui import *


class View(QWidget):
    """Main view of the app."""

    def __init__(self, person, parent=None):
        super(View, self).__init__(parent)
        self.person = person
        self.layout = QGridLayout(self)

        # Center the widgets by surrounding them with spacers.
        for i, j in [(0, 1), (1, 0), (1, 2), (2, 1)]:
            self.layout.addItem(QSpacerItem(50, 50, QSizePolicy.Expanding,
                                            QSizePolicy.Expanding),
                                i, j)

        self.grid = QGridLayout()
        self.layout.addLayout(self.grid, 1, 1)
        self.le_name = QLabel(self.person.name)
        self.le_age = QLabel(str(self.person.age))
        self.le_weight = QLabel(str(self.person.weight))
        self.pb_eat = QPushButton("\n.        Eat        .\n")
        self.grid.addWidget(QLabel("Name:"), 0, 0)
        self.grid.addWidget(self.le_name, 0, 1)
        self.grid.addWidget(QLabel("Age:"), 1, 0)
        self.grid.addWidget(self.le_age, 1, 1)
        self.grid.addWidget(QLabel("Weight:"), 2, 0)
        self.grid.addWidget(self.le_weight, 2, 1)
        self.grid.addWidget(self.pb_eat, 3, 0)

    def update_label_weight(self):
        """Update the label for the weight to the current value."""
        self.le_weight.setText(str(self.person.weight))
