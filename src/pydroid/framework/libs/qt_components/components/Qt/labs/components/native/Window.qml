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

import Qt 4.7
import "." 1.0

Item {
    id: root
    width: screen.displayWidth
    height: screen.displayHeight

    property alias color: background.color

    default property alias content: windowContent.data

    // Read only property true if window is in portrait
    property alias inPortrait: window.portrait

    // Extendend API (for fremantle only)
    property bool allowSwitch: true
    property bool allowClose:  true

    property Style platformStyle: WindowStyle{}

    signal orientationChangeAboutToStart
    signal orientationChangeStarted
    signal orientationChangeFinished

    Rectangle {
        id: background
        anchors.fill: parent
        color: platformStyle.colorBackground
    }

    Item {
        id: window
        property bool portrait

        width: window.portrait ? screen.displayHeight : screen.displayWidth
        height: window.portrait ? screen.displayWidth : screen.displayHeight

        anchors.centerIn: parent

        MouseArea {
            id: switchButton
            enabled: allowSwitch && screen.allowSwipe
            z: platformStyle.buttonZIndex
            width: platformStyle.buttonWidth; height: platformStyle.buttonHeight
            anchors {
                top: parent.top; left: parent.left
                topMargin: platformStyle.buttonVerticalMargin; leftMargin: platformStyle.buttonHorizontalMargin
            }
            onClicked: screen.minimized = true
        }

        MouseArea {
            id: closeButton
            enabled: allowClose && screen.allowSwipe
            z: platformStyle.buttonZIndex
            width: platformStyle.buttonWidth; height: platformStyle.buttonHeight
            anchors {
                top: parent.top; right: parent.right
                topMargin: platformStyle.buttonVerticalMargin; rightMargin: platformStyle.buttonHorizontalMargin
            }
            onClicked: Qt.quit()
        }

        Item {
            id: windowContent
            width: parent.width
            height: parent.height - heightDelta

            // Used for resizing windowContent when virtual keyboard appears
            property int heightDelta: 0

            objectName: "windowContent"
            property string objectNameEx: "windowContent"
            clip: true

            Connections {
                id: inputContextConnection
                target: inputContext
                onSoftwareInputPanelVisibleChanged: inputContextConnection.updateWindowContentHeightDelta();

                onSoftwareInputPanelRectChanged: inputContextConnection.updateWindowContentHeightDelta();

                function updateWindowContentHeightDelta() {
                    if(inputContext.customSoftwareInputPanelVisible)
                        return

                    if (root.inPortrait)
                        windowContent.heightDelta = inputContext.softwareInputPanelRect.width
                    else
                        windowContent.heightDelta = inputContext.softwareInputPanelRect.height
                }
            }
        }

        SoftwareInputPanel {
            id: softwareInputPanel
            active: inputContext.customSoftwareInputPanelVisible
            anchors.bottom: parent.bottom

            onHeightChanged: {
                windowContent.heightDelta = height
            }

            Loader {
                id: softwareInputPanelLoader
                width: parent.width
                sourceComponent: inputContext.customSoftwareInputPanelComponent
            }
        }

        Snapshot {
            id: snapshot
            anchors.centerIn: parent
            width: screen.displayWidth
            height: screen.displayHeight
            snapshotWidth: screen.displayWidth
            snapshotHeight: screen.displayHeight
            opacity: 0
        }

        state: screen.orientationString

        states: [
            State {
                name: "Landscape"
                PropertyChanges { target: window; rotation: 0; portrait: false; }
            },
            State {
                name: "Portrait"
                PropertyChanges { target: window; rotation: 270; portrait: true; }
            },
            State {
                name: "LandscapeInverted"
                PropertyChanges { target: window; rotation: 180; portrait: false; }
            },
            State {
                name: "PortraitInverted"
                PropertyChanges { target: window; rotation: 90; portrait: true; }
            }
        ]

        transitions: [
        Transition {
            // use this transition when sip is visible
            from: (inputContext.softwareInputPanelVisible ?  "*" : "disabled")
            to:   (inputContext.softwareInputPanelVisible ?  "*" : "disabled")
            PropertyAction { target: window; properties: "rotation"; }
            ScriptAction {
                script: {
                    root.orientationChangeAboutToStart();
                    platformWindow.startSipOrientationChange(window.rotation);
                    // note : we should really connect these signals to MInputMethodState
                    // signals so that they are emitted at the appropriate time
                    // but there aren't any
                    root.orientationChangeStarted();
                    root.orientationChangeFinished();
                }
            }
        },
        Transition {
            // use this transition when sip is not visible
            from: (screen.minimized ? "disabled" : (inputContext.softwareInputPanelVisible ? "disabled" : "*"))
            to:   (screen.minimized ? "disabled" : (inputContext.softwareInputPanelVisible ? "disabled" : "*"))
            SequentialAnimation {
                alwaysRunToEnd: true

                ScriptAction {
                    script: {
                        snapshot.take();
                        snapshot.opacity = 1.0;
                        snapshot.rotation = -window.rotation;
                        snapshot.smooth = false; // Quick & coarse rotation consistent with MTF
                        platformWindow.animating = true;
                        root.orientationChangeAboutToStart();
                    }
                }
                PropertyAction { target: window; properties: "portrait"; }
                ScriptAction {
                    script: {
                        windowContent.opacity = 0.0;
                        root.orientationChangeStarted();
                    }
                }
                ParallelAnimation {
                    NumberAnimation { target: windowContent; property: "opacity";
                                      to: 1.0; easing.type: Easing.InOutExpo; duration: 800; }
                    NumberAnimation { target: snapshot; property: "opacity";
                                      to: 0.0; easing.type: Easing.InOutExpo; duration: 800; }
                    RotationAnimation { target: window; property: "rotation";
                                        direction: RotationAnimation.Shortest;
                                        easing.type: Easing.InOutExpo; duration: 800; }
                }
                ScriptAction {
                    script: {
                        snapshot.free();
                        root.orientationChangeFinished();
                        platformWindow.animating = false;
                    }
                }
            }
        }
        ]

        focus: true
        Keys.onReleased: {
            if (event.key == Qt.Key_I && event.modifiers == Qt.AltModifier) {
                theme.inverted = !theme.inverted;
            }
            if (event.key == Qt.Key_E && event.modifiers == Qt.AltModifier) {
                if(screen.currentOrientation == Screen.Landscape) {
                    screen.allowedOrientations = Screen.Portrait;
                } else if(screen.currentOrientation == Screen.Portrait) {
                    screen.allowedOrientations = Screen.LandscapeInverted;
                } else if(screen.currentOrientation == Screen.LandscapeInverted) {
                    screen.allowedOrientations = Screen.PortraitInverted;
                } else if(screen.currentOrientation == Screen.PortraitInverted) {
                    screen.allowedOrientations = Screen.Landscape;
                }
            }
        }
    }
}
