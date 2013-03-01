 import QtQuick 1.0

BorderImage {
     property string color: ""

     signal clicked

Rectangle {
id: shade
         anchors.fill: parent; radius: 10; color: "black"; opacity: 0
     }
states: State {
         name: "pressed"; when: mouseArea.pressed == true
         PropertyChanges { target: shade; opacity: .4 }
     }

 }
