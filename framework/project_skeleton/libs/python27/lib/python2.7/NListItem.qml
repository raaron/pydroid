import Qt 4.7

Rectangle {
    width: parent.width
    height: 40
    smooth: true
    transformOrigin: Item.Center
    NTextInput {
        id: my_value
        color: "#ED3300"
        text: qsTr(item_text)
        anchors.verticalCenter: parent.verticalCenter
    }
   MouseArea {
        width: 32
        height: 40
        anchors.right: parent.right
        anchors.rightMargin: 32
        NButton{
            anchors.fill: parent
            source: "edit.svg"
            }
        onPressed: edit_item(index, my_value.text)
    }

    MouseArea {
            width: 32
            height: 40
            anchors.right: parent.right
            anchors.rightMargin: 0
           

            NButton {
                anchors.fill: parent
                source: "delete.svg"
            }
            onPressed: remove_item(index)
        }

}
