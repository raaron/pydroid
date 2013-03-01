import Qt 4.7

ListView {
        width: parent.width
        height: parent.height*0.8
        boundsBehavior: Flickable.StopAtBounds
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        model: items

        delegate:
        NListItem {
            opacity: 0.7
            anchors.leftMargin: 0
        }
    }   

