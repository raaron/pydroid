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
import "constants.js" as UI

/*
   Class: TumblerButton
   button component that has a label and has click event handling.

   A button is a component that accepts user input and send a clicked() signal for
   the application to handle. The button has resizable properties, event
   handling, and can undergo state changes and transitions.

   The TumblerButton has a fixed width. Longer text will be elided.
   To avoid that for longer texts please set the implicitWidth explicitly.

   <code>
       // Create a button with different icon states:
       // This approach works for all supported states: normal, disabled, pressed, selected, selected && disabled
       TumblerButton {
           text: "Tumbler Button"
       }
   </code>
*/
Item {
    id: tumblerbutton

    /*
     * Property: text
     * [string] The text displayed on button.
     */
    property string text: "Get Value"

    /*
     * Property: pressed
     * [bool] (ReadOnly) Is true when the button is pressed
     */
    property alias pressed: mouse.pressed

    property QtObject style: TumblerButtonStyle{}

    /*
     * Event: clicked
     * Is emitted after the button is released
     */
    signal clicked

    height: UI.SIZE_BUTTON
    width: UI.WIDTH_TUMBLER_BUTTON // fixed width to prevent jumping size after selecting value from tumbler

    BorderImage {
        border { top: UI.CORNER_MARGINS; bottom: UI.CORNER_MARGINS;
            left: UI.CORNER_MARGINS; right: UI.CORNER_MARGINS }
        anchors.fill: parent
        source: mouse.pressed ?
                tumblerbutton.style.pressedBackground : tumblerbutton.enabled ?
                    tumblerbutton.style.background : tumblerbutton.style.disabledBackground;
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        enabled: parent.enabled
        onClicked: {
            parent.clicked()
        }
    }

    Image {
        id: icon

        anchors { right: (label.text != "") ? parent.right : undefined;
            rightMargin: UI.INDENT_DEFAULT;
            horizontalCenter: (label.text != "") ? undefined : parent.horizontalCenter;
            verticalCenter: parent.verticalCenter;
        }
        height: sourceSize.height
        width: sourceSize.width
        source: "image://theme/meegotouch-combobox-indicator" +
                (tumblerbutton.style.inverted ? "-inverted" : "") +
                (tumblerbutton.enabled ? "" : "-disabled") +
                (mouse.pressed ? "-pressed" : "")
    }

    Text {
        id: label

        anchors { left: parent.left; right: icon.left;
            leftMargin: UI.INDENT_DEFAULT; rightMargin: UI.INDENT_DEFAULT;
            verticalCenter: parent.verticalCenter }
        font { family: UI.FONT_FAMILY; pixelSize: UI.FONT_DEFAULT_SIZE;
            bold: UI.FONT_BOLD_BUTTON; capitalization: tumblerbutton.style.fontCapitalization }
        text: tumblerbutton.text
        color: (mouse.pressed) ? 
            tumblerbutton.style.pressedTextColor :
                (tumblerbutton.enabled) ?
                    tumblerbutton.style.textColor : tumblerbutton.style.disabledTextColor ;
        horizontalAlignment: Text.AlignLeft
        elide: Text.ElideRight
    }
}
