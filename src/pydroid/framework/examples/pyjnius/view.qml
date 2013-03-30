import QtQuick 1.0

Rectangle {
  id: page
  width: 500;
  height: 200
  color: "lightgray"

  Text {
    id: helloText
    text: data_provider.get_text()
    y: 30
    anchors.horizontalCenter: page.horizontalCenter
    font.pointSize: 24
    font.bold: true
  }

  Text {
    id: sensorDataText
    text: data_provider.get_sensor_data()
    anchors.horizontalCenter: page.horizontalCenter
    anchors.top: helloText.bottom
    font.pointSize: 18
  }
}
