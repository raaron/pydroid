import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    anchors.fill : parent
    id: rootWindow
    initialPage : mainPage
    showStatusBar : false
    showToolBar : true

    Page {
        id : mainPage
        anchors.fill : parent
        tools : commonTools
        Flickable {
            anchors.topMargin : 16
            anchors.fill : parent
            Column {
                anchors.fill : parent
                spacing : 16
                Text {
                    text: "<h1>PySide & Qt @ Android Example</h1>"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: date_provider.get_date()
                    font.pixelSize : 32
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                TextField {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id : entryField
                    width : 400
                    height : 52
                    text : "edit me..."
                }
                Text {
                    text: "Input: " + entryField.text
                    font.pixelSize : 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Image {
                    id : pysideImage
                    anchors.horizontalCenter: parent.horizontalCenter
                    width : 300
                    height : 157
                    smooth : true
                    source : "images/pyside.png"
                }
                Text {
                    id : buttonDisplay
                    text: "Press the buttons below"
                    font.pixelSize : 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }


    ToolBarLayout {
        id: commonTools
        ToolButton { text: "One"
            onClicked : buttonDisplay.text = "Button One clicked"
        }
        ToolButton { text: "Two"
            onClicked : buttonDisplay.text = "Button Two clicked"
        }
        ToolButton { text: "Tools"
            onClicked : {
                toolsMenu.open()
                buttonDisplay.text = "Button Tools clicked"
            }
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }


    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: "Sample menu item 1"
                onClicked : buttonDisplay.text = "Menu 1 clicked"
            }
            MenuItem {
                text: "Sample menu item 2"
                onClicked : buttonDisplay.text = "Menu 2 clicked"
            }
            MenuItem {
                text: "Sample menu item 3"
                onClicked : buttonDisplay.text = "Menu 3 clicked"
            }
        }
    }

    Menu {
        id: toolsMenu
        height : 52
        visualParent: pageStack
        MenuLayout {
            Label { text : "Image rotation" }
            Slider {
                stepSize : 1
                minimumValue : 0
                maximumValue : 360
                valueIndicatorVisible : true
                value : pysideImage.rotation
                onValueChanged : pysideImage.rotation = value
            }

            Label { text : "Image opacity" }
            Slider {
                stepSize : 0.01
                minimumValue : 0.0
                maximumValue : 1.0
                valueIndicatorVisible : true
                value : pysideImage.opacity
                onValueChanged : pysideImage.opacity = value
            }
        }
    }
}