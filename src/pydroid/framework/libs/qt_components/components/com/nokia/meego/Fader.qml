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

// Background dimming
Rectangle {
    id: faderBackground

    property double dim: 0.9
    property int fadeInDuration: 250
    property int fadeOutDuration: 250

    property int fadeInDelay: 0
    property int fadeOutDelay: 0

    property int fadeInEasingType: Easing.InQuint
    property int fadeOutEasingType: Easing.OutQuint

    property url background: ""

    property Item visualParent: null
    property Item originalParent: parent

    // widen the edges to avoid artefacts during rotation
    anchors.topMargin:    -1
    anchors.rightMargin:  -1
    anchors.bottomMargin: -1
    anchors.leftMargin:   -1

    // opacity is passed to child elements - that is not, what we want
    // so we need to use alpha value here
    property double alpha: dim

    signal privateClicked

     //Deprecated, TODO Remove the following two lines on w13
    signal clicked
    onClicked: privateClicked()

    // we need the possibility to fetch the red, green, blue components from a color
    // see http://bugreports.qt.nokia.com/browse/QTBUG-14731
    color: background != "" ? "transparent" : Qt.rgba(0.0, 0.0, 0.0, alpha)
    state: 'hidden'

    anchors.fill: parent

    // eat mouse events
    MouseArea {
        id: mouseEventEater
        anchors.fill: parent
        enabled: faderBackground.alpha != 0.0
        onClicked: { parent.privateClicked() }
    }

    Component {
        id: backgroundComponent
        BorderImage {
            id: backgroundImage
            source: background

            width: faderBackground.width
            height: faderBackground.height

            opacity: faderBackground.alpha
        }
    }
    Loader {id: backgroundLoader}

    onAlphaChanged: {
          if (background && faderBackground.alpha && backgroundLoader.sourceComponent == undefined) {
            backgroundLoader.sourceComponent = backgroundComponent;
          }
          if (!faderBackground.alpha) {
            backgroundLoader.sourceComponent = undefined;
          }
    }

    function findRoot() {
        var next = parent;

        if (next != null) {
            while (next.parent) {
                if(next.objectName == "appWindowContent" || next.objectName == "windowContent"){
                    break
                }

                next = next.parent;
            }
        }
        return next;
    }


    states: [
        State {
            name: "visible"
            PropertyChanges {
                target: faderBackground
                alpha: dim
            }
        },
        State {
            name: "hidden"
            PropertyChanges {
                target: faderBackground
                alpha: 0.0
            }
        }
    ]
    
    transitions: [
        Transition {
            from: "hidden"; to: "visible"
            //reparent fader whenever it is going to be visible
            SequentialAnimation {
                ScriptAction {script: {
                        //console.log("=============00=============");
                        // the algorithm works in the following way:
                        // First:  Check if visualParent property is set; if yes, center the fader in visualParent
                        // Second: If not, center inside window content element
                        // Third:  If no window was found, use root window
                        originalParent = faderBackground.parent;
                        if (visualParent != null) {
                            faderBackground.parent = visualParent
                        } else {
                            var root = findRoot();
                            if (root != null) {
                                faderBackground.parent = root;
                            } else {
                               // console.log("Error: Cannot find root");
                            }
                        }
                    }
                }
                PauseAnimation { duration: fadeInDelay }

                NumberAnimation {
                    properties: "alpha"
                    duration: faderBackground.fadeInDuration
                    easing.type: faderBackground.fadeInEasingType;
                }
            }
        },
        Transition {
            from: "visible"; to: "hidden"
            SequentialAnimation {
                PauseAnimation { duration: fadeOutDelay }

                NumberAnimation {
                    properties: "alpha"
                    duration: faderBackground.fadeOutDuration
                    easing.type: faderBackground.fadeOutEasingType;
                }
                ScriptAction {script: {
                        faderBackground.parent = originalParent;
                    }
                }
            }
        }
    ]
}



