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
import com.nokia.meego 1.0
import "constants.js" as C
import "TumblerIndexHelper.js" as IH

/*
   Class: TumblerDialog
   Dialog that shows a tumbler.
*/
Dialog {
    id: root

    /*
     * Property: titleText
     * [string] If not null, it will be used as the title text for the dialog.
     *          If further customization is needed, use property title instead
     */
    property alias titleText: title.text

    /*
     * Property: items
     * [ListModel] Array of ListModel for each column of the dialog.
     */
    property alias columns: tumbler.columns

    /*
     * Property: acceptButtonText
     * [string] The button text for the accept button.
     */
    property alias acceptButtonText: acceptButton.text

    /*
     * Property: rejectButtonText
     * [string] The button text for the reject button.
     */
    property alias rejectButtonText: rejectButton.text

    // TODO do not dismiss the dialog when empty area is clicked
    style: DialogStyle {
        titleBarHeight: 48
        leftMargin: screen.currentOrientation == Screen.Portrait || screen.currentOrientation == Screen.PortraitInverted ? 16 : 215
        rightMargin: screen.currentOrientation == Screen.Portrait || screen.currentOrientation == Screen.PortraitInverted ? 16 : 215
        centered: true
    }
    title: Text {
        id: title
        objectName: "titleText"
        visible: text.length > 0
        color: "#1080DD"
        font { pixelSize: 32; family: C.FONT_FAMILY_BOLD }
        elide: Text.ElideRight
    }
    content: Item {
        height: 300
        width: parent.width
        Tumbler {
            id: tumbler
            height: 300
            privateDelayInit: true
        }
    }
    buttons: Row {
        height: 56
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 6
        Button {
            id: acceptButton
            onClicked: accept()
            width: (root.width / 2) - 3
            style: ButtonStyle { inverted: true }
            visible: text != ""
        }
        Button {
            id: rejectButton
            onClicked: reject()
            width: (root.width / 2) - 3
            style: ButtonStyle { inverted: true }
            visible: text != ""
        }
    }

    QtObject {
        id: internal
        property bool init: true
    }

    onStatusChanged: {
        if (status == DialogStatus.Opening) {
            tumbler.privateInitialize();

            if (internal.init) {
                IH.saveIndex(tumbler);
                internal.init = false;
            }
            else {
                // restore index when dialog was canceled.
                // another case is when dialog was closed while tumbler was
                // still rotating (Qt sets the index to the last rotated
                // number, need to retore to a previously saved index in
                // this case)
                IH.restoreIndex(tumbler);
            }
        }
    }

    onAccepted: {
        tumbler.privateForceUpdate();
        IH.saveIndex(tumbler);
    }

    onRejected: {
        IH.restoreIndex(tumbler);
    }
}
