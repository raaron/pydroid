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

/*
   Class: CountBubble
   CountBubble component is a flexible shape that holds a number and can be added in lists or
   notification banners for example.
*/

ImplicitSizeItem {
    id: root

    /*
     * Property: largeSized
     * [bool=false] Use small or large count bubble.
     */
    property bool largeSized: false

    /*
     * Property: value
     * [int=0] Reflects the current value.
     */
    property int value: 0

    implicitWidth: internal.getBubbleWidth()
    implicitHeight: largeSized ? 32:24

    BorderImage {
        source: "image://theme/meegotouch-countbubble-background"+(largeSized ? "-large":"")
        anchors.fill: parent
        border { left: 10; top: 10; right: 10; bottom: 10 }
    }

    Text {
        id: text
        height: parent.height
        y:1
        color: largeSized ? "#FFFFFF" : "black"
        font.family: C.FONT_FAMILY
        anchors.horizontalCenter: parent.horizontalCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: largeSized ? 22:18
        text: root.value
    }

    QtObject {
        id: internal

        function getBubbleWidth() {
            if (largeSized) {
                if (root.value < 10)
                    return 32;
                else if (root.value < 100)
                    return 40;
                else if (root.value < 1000)
                    return 52;
                else
                    return text.paintedWidth+19
            } else {
                if (root.value < 10)
                    return 24;
                else if (root.value < 100)
                    return 30;
                else if (root.value < 1000)
                    return 40;
                else
                    return text.paintedWidth+13
            }
        }
    }
}
