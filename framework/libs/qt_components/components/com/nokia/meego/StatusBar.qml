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

import "UIConstants.js" as UI

Item {
    id: root

    anchors.top: parent.top
    width: parent ? parent.width : 0
    height: background.height

    // Set StatusBar in the Z index required by Window
    z: UI.STATUS_BAR_Z_INDEX

    // Whether status bar should be showed
    property bool showStatusBar: true

    // Extended API (fremantle only)
    property bool showHelp: true

    // Styling for the StatusBar
    property Style platformStyle: StatusBarStyle {}

    //Statusbar background
    BorderImage {
        id: background
        width: parent.width;
        source: platformStyle.background

        // Time Clock
        Text {
            id: time_indicator
            text: maemo.currentTime
            color: platformStyle.indicatorColor

            anchors {
                right: parent.right
                rightMargin: platformStyle.paddingSmall
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: 2
            }

            font {
                family: platformStyle.indicatorFont
                pixelSize: platformStyle.indicatorFontSize
            }
        }

        // Indicators
        Row {
            id: left_indicators
            spacing: platformStyle.paddingSmall

            anchors {
                left: parent.left
                leftMargin:platformStyle.paddingSmall
                bottom: time_indicator.baseline
            }

            // battery indicator
            Image {
                id: battery_indicator
                anchors.bottom: parent.bottom

                property int level

                NumberAnimation on level {
                    from: 0; to: platformStyle.batteryLevels;
                    duration: platformStyle.batteryPeriod; loops: Animation.Infinite
                    running: maemo.batteryInfo.charging && root.visible && platformWindow.active
                }

                source: platformStyle.batteryFrames +
                        (maemo.batteryInfo.charging ?
                             (level > 0 ? level : "-low") :
                             (maemo.batteryInfo.batteryLevel > 0 ?
                                  maemo.batteryInfo.batteryLevel : "-verylow"))

            }

            // Offline indicator
            Image {
                id: signal_indicator
                anchors.bottom: parent.bottom
                fillMode: Image.PreserveAspectFit

                states: [
                    State {
                        name: "OFFLINE"
                        when: maemo.cellInfo.status === CellInfo.NoServNoSIM ||
                              maemo.cellInfo.status === CellInfo.NoServSimRejected ||
                              maemo.cellInfo.status === CellInfo.PowerOff
                        PropertyChanges {target: signal_indicator; source: platformStyle.cellStatus + maemo.cellInfo.mode; visible: true}
                    },
                    State {
                        name: "ONLINE"
                        when: maemo.cellInfo.status < CellInfo.NoServ
                        PropertyChanges {target: signal_indicator; source: platformStyle.cellSignalFrames + maemo.cellInfo.strength; visible: true}
                    },
                    State {
                        name: "HIDDEN"
                        PropertyChanges {target: signal_indicator; visible: false}
                    }
                ]
            }

            // Operator name
            Text {
                id: provider_indicator
                visible: maemo.cellInfo.status < CellInfo.NoServ
                anchors.baseline: parent.bottom
                anchors.baselineOffset: -1

                text: maemo.cellInfo.provider
                color: platformStyle.indicatorColor

                font {
                    family: platformStyle.indicatorFont
                    pixelSize: platformStyle.indicatorFontSize
                }
            }

            // Range indicator
            Image {
                id: range_indicator
                anchors.bottom: parent.bottom
                fillMode: Image.PreserveAspectFit

                // For connecting aniamtions
                property int index

                NumberAnimation on index {
                    from: 1; to: platformStyle.numberOfWlanFrames
                    easing.type:Easing.OutCubic; loops: Animation.Infinite; duration: platformStyle.wlanPeriod;
                    running: range_indicator.state === "CONNECTING" && maemo.networkInfo.bearer === "wlan"
                }
                NumberAnimation on index {
                    from: 1; to: platformStyle.numberOfCellFrames
                    loops: Animation.Infinite; duration: platformStyle.cellPeriod;
                    running: range_indicator.state === "CONNECTING" && maemo.networkInfo.bearer !== "wlan"
                }

                states: [
                    State {
                        name: "OFFLINE"
                        when:  maemo.networkInfo.status === NetworkInfo.Disconnected && maemo.cellInfo.status < CellInfo.NoServ
                        PropertyChanges {target: range_indicator; source: platformStyle.cellRangeMode + maemo.cellInfo.mode; visible: true}
                    },
                    State {
                        name: "CONNECTING"
                        when:  maemo.networkInfo.status === NetworkInfo.Connecting && maemo.cellInfo.status !== CellInfo.PowerOff
                        PropertyChanges {target: range_indicator; source: platformStyle.cellRangeMode + (maemo.networkInfo.bearer === "wlan" ? maemo.networkInfo.bearer: "packetdata" ) + range_indicator.index; visible: true}
                    },
                    State {
                        name: "ONLINE"
                        when: maemo.networkInfo.status === NetworkInfo.Connected &&
                              (maemo.networkInfo.bearer === "wlan" || maemo.cellInfo.status < CellInfo.NoServ)
                        PropertyChanges {target: range_indicator; source: platformStyle.cellRangeMode + maemo.networkInfo.bearer + (maemo.networkInfo.bearer === "wlan" ? "": "-active"); visible: true}
                    },
                    State {
                        name: "SUSPENDED"
                        when: maemo.networkInfo.status === NetworkInfo.Connected &&
                              maemo.networkInfo.bearer !== "wlan" && maemo.cellInfo.Status >= CellInfo.NoServ
                        PropertyChanges {target: range_indicator; source: platformStyle.cellStatus + "-suspended"; visible: true}
                    },
                    State {
                        name: "HIDDEN"
                        when: maemo.networkInfo.status === NetworkInfo.Disconnected && maemo.cellInfo.status >= CellInfo.NoServ
                        PropertyChanges {target: range_indicator; visible: false}
                    }
                ]
            }
        }
    }

    Rectangle {
        id: help_background
        width: parent.width; height: parent.height
        color: "black"; opacity: 0.0; enabled: showHelp

        Item {
            id: help_contents
            opacity: 0.0
            anchors.fill: parent

            Image {
                source: platformStyle.homeButton
                anchors {
                    left: parent.left
                    leftMargin: platformStyle.paddingSmall
                    verticalCenter: parent.verticalCenter
                }
            }

            Image {
                source: platformStyle.closeButton
                anchors {
                    right: parent.right
                    rightMargin: platformStyle.paddingSmall
                    verticalCenter: parent.verticalCenter
                }
            }

            Text {
                color: platformStyle.indicatorColor
                anchors.centerIn: parent

                //% "'Tap' to switch or close"
                text: textTranslator.translate("qtn_statusbar_help")

                font {
                    family: platformStyle.indicatorFont
                    pixelSize: platformStyle.helpFontSize
                }
            }
        }
    }

    Timer{
        id: stimer
        interval: platformStyle.showHelpDuration; running: showHelp; repeat: false;
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onPressed: {
            //FIXME: Implement a StatusApplet. See symbian Belle for details
            console.log("Area clicked")
        }
    }

    states: [
        State {
            name: "hidden"
            when: showStatusBar == false
            PropertyChanges {target: root; anchors.topMargin: -root.height; visible: false}

        },
        State {
            name: "start"
            when: stimer.running == true
            PropertyChanges {target: root; height: platformStyle.paddingSmall * 8}
            PropertyChanges {target: help_background; opacity: 1.0 }
            PropertyChanges {target: help_contents; opacity: 1.0; }
        }
    ]

    transitions: [
        // Transition between active and inactive states.
        Transition {
            from: ""; to: "hidden"; reversible: true
            ParallelAnimation {
                PropertyAnimation {properties: "anchors.topMargin"; easing.type: Easing.InOutExpo;  duration: platformStyle.visibilityTransitionDuration }
                PropertyAnimation { target: statusBar; properties: "visible"; }
            }
        },
        Transition {
            from: "start"; to: ""; reversible:  false
            SequentialAnimation {
                PropertyAnimation {targets: help_contents; properties: "opacity"; easing.type: Easing.InOutExpo;  duration: platformStyle.helpTransitionDuration }
                PauseAnimation    {duration:  platformStyle.visibilityTransitionDuration}
                PropertyAnimation {targets: root; properties:"height"; easing.type: Easing.InOutExpo;  duration: platformStyle.helpTransitionDuration }
                PauseAnimation    {duration:  platformStyle.visibilityTransitionDuration}
                PropertyAnimation {targets: help_background; properties: "opacity"; easing.type: Easing.InOutExpo;  duration: platformStyle.helpTransitionDuration }
            }
        }
    ]
}

