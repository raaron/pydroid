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
import "." 1.0
import "Utils.js" as Utils
import "EditBubble.js" as Private

Item {
    id: bubble

    property Item textInput: null
    property bool valid: rect.canCut || rect.canCopy || rect.canPaste

    property alias privateRect: rect

    property Style platformStyle: EditBubbleStyle {}

    anchors.fill: parent

    Item {
        id: rect
        visible: false
        width: row.width
        height: row.height

        property int arrowOffset: 0
        property int arrowBorder: platformStyle.arrowMargin
        property bool arrowDown: true
        property bool changingText: false
        property bool pastingText: false

        property bool validInput: textInput != null
        property bool canCut: rect.canCopy && !textInput.readOnly

        // TextEdit will have echoMode == null
        property bool canCopy: textSelected && (textInput.echoMode == null || textInput.echoMode == TextInput.Normal)
        property bool canPaste: validInput && (textInput.canPaste && !textInput.readOnly)
        property bool textSelected: validInput && (textInput.selectedText != "")

        z: 1020

        onWidthChanged: {
            if (rect.visible)
                Private.adjustPosition(bubble);
        }

        onHeightChanged: {
            if (rect.visible)
                Private.adjustPosition(bubble);
        }

        BasicRow {
            id: row
            Component.onCompleted: Private.updateButtons(row);

            EditBubbleButton {
                id: buttonCut
                text: textTranslator.translate("qtn_comm_cut");
                visible: rect.canCut
                onClicked: {
                    rect.changingText = true;
                    textInput.cut();
                    rect.changingText = false;
                    Private.closePopup(bubble);
                }
                onVisibleChanged: Private.updateButtons(row);
            }

            EditBubbleButton {
                id: buttonCopy
                text: textTranslator.translate("qtn_comm_copy");
                visible: rect.canCopy
                onClicked: {
                    textInput.copy();
                    Private.closePopup(bubble);
                }
                onVisibleChanged: Private.updateButtons(row);
            }

            EditBubbleButton {
                id: buttonPaste
                text: textTranslator.translate("qtn_comm_paste");
                visible: rect.canPaste
                onClicked: {
                    rect.changingText = true;
                    if (textInput.inputMethodComposing) {
                        var cursorAdjust = textInput.preedit.length - textInput.preeditCursorPosition;
                        inputContext.reset();
                        textInput.cursorPosition -= cursorAdjust;
                    }
                    rect.pastingText = true;
                    var text = textInput.text;
                    textInput.paste();
                    // PastingText is set to false and clipboard is cleared if we catch onTextChanged
                    if (rect.pastingText && text == textInput.text) {
                        var root = Utils.findRootItemNotificationBanner(textInput);

                        // create notification banner
                        var bannerInstance = notificationBanner.createObject(root);
                        bannerInstance.show();
                        bannerInstance.timerEnabled = true;
                        rect.pastingText = false;
                    }
                    rect.changingText = false;
                    Private.closePopup(bubble);
                }

                onVisibleChanged: Private.updateButtons(row);
            }

            Component {
                id : notificationBanner
                NotificationBanner{
                    id: errorBannerPrivate
                    text: textTranslator.translate("qtn_comm_cantpaste");
                    timerShowTime: 5*1000
                    topMargin: 8
                    leftMargin: 8
                }
            }
        }

        Image {
            source: platformStyle.bottomTailBackground
            visible: rect.arrowDown && bubble.valid

            anchors.bottom: row.bottom
            anchors.horizontalCenter: row.horizontalCenter
            anchors.horizontalCenterOffset: rect.arrowOffset
        }

        Image {
            source: platformStyle.topTailBackground
            visible: !rect.arrowDown && bubble.valid

            anchors.bottom: row.top
            anchors.bottomMargin: -platformStyle.backgroundMarginBottom - 2

            anchors.horizontalCenter: row.horizontalCenter
            anchors.horizontalCenterOffset: rect.arrowOffset
        }
    }

    state: "closed"

    states: [
        State {
            name: "opened"
            ParentChange { target: rect; parent: Utils.findRootItem(textInput); }
            PropertyChanges { target: rect; visible: true; }
        },
        State {
            name: "closed"
            ParentChange { target: rect; parent: bubble; }
            PropertyChanges { target: rect; visible: false; }
        }
    ]

    Connections {
        target: Utils.findFlickable(textInput)
        onContentYChanged: Private.adjustPosition(bubble)
    }

    Connections {
        target: screen
        onCurrentOrientationChanged: Private.adjustPosition(bubble)
    }

    Connections {
        target: textInput
        onTextChanged: {
            if (rect.pastingText) {
                inputContext.clearClipboard();
                rect.pastingText = false;
            }
        }
    }
}
