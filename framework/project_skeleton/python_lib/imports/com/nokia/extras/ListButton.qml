/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 1.1
import Qt.labs.components 1.0 
import "." 1.0
import com.nokia.meego 1.0

Item {
    id: button

    // Common public API
    property bool checked: false
    property bool checkable: false
    property alias pressed: mouseArea.pressed
    property alias text: label.text
    property url iconSource

    signal clicked

    // Used in ButtonGroup.js to set the segmented look on the buttons.
    property string __buttonType

    // Styling for the Button
    property Style platformStyle: ButtonStyle {}

    // Deprecated, TODO remove
    property alias style: button.platformStyle

    implicitWidth: iconAndLabel.prefferedWidth
    implicitHeight: platformStyle.buttonHeight

    property alias font: label.font

    property int padding_xlarge: 16
    property int button_label_marging: 10
    property int size_icon_default: 32
    
    BorderImage {
        id: background
        anchors.fill: parent

        border { left: button.platformStyle.backgroundMarginLeft; top: button.platformStyle.backgroundMarginTop;
                 right: button.platformStyle.backgroundMarginRight; bottom: button.platformStyle.backgroundMarginBottom }
        source: !enabled ?
                  (checked ? button.platformStyle.checkedDisabledBackground : button.platformStyle.disabledBackground) :
                  pressed ?
                      button.platformStyle.pressedBackground :
                  checked ?
                      button.platformStyle.checkedBackground :
                      button.platformStyle.background;
    }

    Item {
        id: iconAndLabel
        property real xMargins: icon.visible ? (padding_xlarge * (label.visible ? 3 : 2)) : (button_label_marging * 2)
        property real prefferedWidth: xMargins + (icon.visible ? icon.width : 0) + (label.visible ? label.prefferedSize.width : 0)

        width: xMargins + (icon.visible ? icon.width : 0) + (label.visible? label.width : 0)
        height: platformStyle.buttonHeight

        anchors.verticalCenter: button.verticalCenter
        anchors.horizontalCenter: button.horizontalCenter
        anchors.verticalCenterOffset: -1

        Image {
            id: icon
            source: button.iconSource
            x: padding_xlarge
            anchors.verticalCenter: iconAndLabel.verticalCenter
            width: size_icon_default
            height: size_icon_default
            visible: source != ""
        }

        Label {
            id: label  
            x: icon.visible ? (icon.x + icon.width + padding_xlarge) : button_label_marging
            anchors.verticalCenter: iconAndLabel.verticalCenter
            anchors.verticalCenterOffset: 1

            property real availableWidth: button.width - iconAndLabel.xMargins - (icon.visible ? icon.width : 0)
            width: Math.min(prefferedSize.width, availableWidth)

            elide: Text.ElideRight
            font.family: button.platformStyle.fontFamily
            font.weight: button.platformStyle.fontWeight
            font.pixelSize: button.platformStyle.fontPixelSize
            font.capitalization: button.platformStyle.fontCapitalization
            color: !enabled ? button.platformStyle.disabledTextColor :
                   pressed ? button.platformStyle.pressedTextColor :
                   checked ? button.platformStyle.checkedTextColor :
                             button.platformStyle.textColor;
            text: ""
            visible: text != ""

            Label {
                id: prefferedSize
                font: parent.font
                text: parent.text
                visible: false
            }
            property alias prefferedSize: prefferedSize
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: {
            if (button.checkable)
                button.checked = !button.checked;
            button.clicked();
        }
    }
}
