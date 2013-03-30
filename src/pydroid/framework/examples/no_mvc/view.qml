import QtQuick 1.0

Rectangle {
  id: page
  width: 500; height: 200
  color: "lightgray"

  Text {
    id: helloText
    text: "No-MVC Example\n\nExample without Model-View-\nController (MVC) structure.\n\nEdit the following files:\n\n\tapp/\n\t\t- main.py\n\t\t- view.qml"
    y: 30
    anchors.horizontalCenter: page.horizontalCenter
    font.pointSize: 24; font.bold: true
  }
}
