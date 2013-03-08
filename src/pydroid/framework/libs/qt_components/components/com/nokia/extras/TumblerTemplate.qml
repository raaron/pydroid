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
import "constants.js" as C

Item {
    id: template
    objectName: "tumblerColumn" + index

    property Item tumblerColumn
    property int index: -1
    property Item view: viewContainer.item

    opacity: enabled ? C.TUMBLER_OPACITY_FULL : C.TUMBLER_OPACITY
    width: childrenRect.width
    visible: tumblerColumn ? tumblerColumn.visible : false
    enabled: tumblerColumn ? tumblerColumn.enabled : true
    onTumblerColumnChanged: {
        if (tumblerColumn)
            viewContainer.sourceComponent = tumblerColumn.privateLoopAround ? pViewComponent : lViewComponent;
    }

    Loader {
        id: viewContainer
        width: tumblerColumn ? tumblerColumn.width : 0
        height: parent.height - container.height - 2*C.TUMBLER_BORDER_MARGIN // decrease by text & border heights
    }

    Component {
        // Component for loop around column
        id: pViewComponent
        PathView {
            id: pView

            model: tumblerColumn ? tumblerColumn.items : undefined
            currentIndex: tumblerColumn ? tumblerColumn.selectedIndex : 0
            preferredHighlightBegin: (height / 2) / (C.TUMBLER_ROW_HEIGHT * pView.count)
            preferredHighlightEnd: preferredHighlightBegin
            highlightRangeMode: PathView.StrictlyEnforceRange
            clip: true
            delegate: defaultDelegate
            highlight: defaultHighlight
            interactive: template.enabled
            anchors.fill: parent

            onMovementStarted: {
                internal.movementCount++;
            }
            onMovementEnded: {
                internal.movementCount--;
                root.changed(template.index) // got index from delegate
            }

            Rectangle {
                width: 1
                height: parent.height
                color: C.TUMBLER_COLOR_TEXT
                opacity: C.TUMBLER_OPACITY_LOW
            }

            path: Path {
                 startX: template.width / 2; startY: 0
                 PathLine {
                     x: template.width / 2
                     y: C.TUMBLER_ROW_HEIGHT * pView.count
                 }
            }
        }
    }

    Component {
        // Component for non loop around column
        id: lViewComponent
        ListView {
            id: lView

            model: tumblerColumn ? tumblerColumn.items : undefined
            currentIndex: tumblerColumn ? tumblerColumn.selectedIndex : 0
            preferredHighlightBegin: Math.floor((height - C.TUMBLER_ROW_HEIGHT) / 2)
            preferredHighlightEnd: preferredHighlightBegin + C.TUMBLER_ROW_HEIGHT
            highlightRangeMode: ListView.StrictlyEnforceRange
            clip: true
            delegate: defaultDelegate
            highlight: defaultHighlight
            interactive: template.enabled
            anchors.fill: parent

            onMovementStarted: {
                internal.movementCount++;
            }
            onMovementEnded: {
                internal.movementCount--;
                root.changed(template.index) // got index from delegate
            }

            Rectangle {
                width: 1
                height: parent.height
                color: C.TUMBLER_COLOR_TEXT
                opacity: C.TUMBLER_OPACITY_LOW
            }
        }
    }

    Item {
        id: container
        anchors.top: viewContainer.bottom
        width: tumblerColumn ? tumblerColumn.width : 0
        height: internal.hasLabel ? C.TUMBLER_LABEL_HEIGHT : 0 // internal.hasLabel is from root tumbler

        Text {
            id: label

            text: tumblerColumn ? tumblerColumn.label : ""
            elide: Text.ElideRight
            horizontalAlignment: "AlignHCenter"
            color: C.TUMBLER_COLOR_LABEL
            font { family: C.FONT_FAMILY_LIGHT; pixelSize: C.FONT_LIGHT_SIZE }
            anchors { fill: parent; margins: C.TUMBLER_MARGIN}
        }
    }

    Component {
        id: defaultDelegate

        Item {
            width: tumblerColumn.width
            height: C.TUMBLER_ROW_HEIGHT

            Text {
                id: txt
                elide: Text.ElideRight
                horizontalAlignment: "AlignHCenter"
                color: C.TUMBLER_COLOR_TEXT
                font { family: C.FONT_FAMILY_BOLD; pixelSize: C.FONT_DEFAULT_SIZE }
                anchors { fill: parent; margins: C.TUMBLER_MARGIN }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (template.view.interactive) {
                            tumblerColumn.selectedIndex = index;  // got index from delegate
                            root.changed(template.index);
                        }
                    }
                }
            }

            Component.onCompleted: {
                try {
                    // Legacy. "value" use to be the role which was used by delegate
                    txt.text = value
                } catch(err) {
                    try {
                        // "modelData" available for JS array and for models with one role
                        txt.text = modelData
                    } catch (err) {
                        try {
                            // C++ models have "display" role available always
                            txt.text = display
                        } catch(err) {
                        }
                    }
                }
            }
        }
    }

    Component {
        id: defaultHighlight

        Image {
            id: highlight
            objectName: "highlight"
            width: tumblerColumn ? tumblerColumn.width : 0
            source: "image://theme/meegotouch-button-objectmenu-background-background-selected-horizontal-right"
            fillMode: Image.TileHorizontally
        }
    }
}
