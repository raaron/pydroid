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
import "Tumbler.js" as Engine
import "constants.js" as C

/*
   Class: Tumbler
   A tumbler.
*/
ImplicitSizeItem {
    id: root

    /*
     * Property: items
     * [ListModel] Array of ListModel for each column of the dialog.
     */
    property list<Item> columns

    /*
     * Event: changed
     * Is emitted when the value of the tumbler changes.
     */
    signal changed(int index)

    /* private */
    property bool privateDelayInit: false
    property list<Item> privateTemplates

    implicitWidth: C.TUMBLER_WIDTH
    implicitHeight: screen.width > screen.height ?
                        C.TUMBLER_HEIGHT_LANDSCAPE :
                        C.TUMBLER_HEIGHT_PORTRAIT

    /* private */
    function privateInitialize() {
        if (!internal.initialized) {
            Engine.initialize();
            internal.initialized = true;
        }
    }

    /* private */
    function privateForceUpdate() {
        Engine.forceUpdate();
    }

    anchors.fill: parent
    clip: true
    Component.onCompleted: {
        if (!privateDelayInit && !internal.initialized) {
            Engine.initialize();
            internal.initialized = true;
        }
    }
    onChanged: {
        if (internal.movementCount == 0)
            Engine.forceUpdate();
    }
    onColumnsChanged: {
        if (internal.initialized) {
            // when new columns are added, the system first removes all
            // the old columns
            internal.initialized = false;
            Engine.clear();
            internal.reInit = true;
        } else if (internal.reInit && columns.length > 0) {
            // timer is used because the new columns are added one by one
            // we only want to act after the last column is added
            internal.reInit = false;
            columnChangedTimer.restart();
        }
    }
    onWidthChanged: {
        Engine.layout();
    }

    QtObject {
        id: internal

        property int movementCount: 0
        property bool initialized: false
        property bool reInit: false
        property bool hasLabel: false

        property Timer timer: Timer {
            id: columnChangedTimer
            interval: 50
            onTriggered: {
                Engine.initialize();
                internal.initialized = true;
            }
        }
    }

    BorderImage {
        width: parent.width
        height: internal.hasLabel ?
                    parent.height - C.TUMBLER_LABEL_HEIGHT : // decrease by bottom text height
                    parent.height
        source: "image://theme/meegotouch-button-objectmenu-background"
        anchors.top: parent.top
        border { left: C.TUMBLER_BORDER_MARGIN; top: C.TUMBLER_BORDER_MARGIN; right: C.TUMBLER_BORDER_MARGIN; bottom: C.TUMBLER_BORDER_MARGIN }
    }
    
    Rectangle {
        width: parent.width
        height: internal.hasLabel ?
                    parent.height - C.TUMBLER_LABEL_HEIGHT - 2 * C.TUMBLER_BORDER_MARGIN : // decrease by bottom text & border height
                    parent.height - 2*C.TUMBLER_BORDER_MARGIN
        color: C.TUMBLER_COLOR
        anchors { top: parent.top; topMargin: C.TUMBLER_BORDER_MARGIN }
    }

    Row {
        id: tumblerRow
        anchors { fill: parent; topMargin: 1 }
    }
}
