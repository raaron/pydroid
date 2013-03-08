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
import com.nokia.extras 1.0
import "constants.js" as C
import "TumblerIndexHelper.js" as TH

/*
   Class: TimePickerDialog
   Dialog that shows a time picker.
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
     * Property: hour
     * [int] The displayed hour (in 24h format).
     */
    property int hour: 0

    /*
     * Property: minute
     * [int] The displayed minute.
     */
    property int minute: 0

    /*
     * Property: second
     * [int] The displayed second.
     */
    property int second: 0

    /*
     * Property: fields
     * [int=DateTime.All] Sets if the time picker should show hours, minutes,
     *                          and/or seconds.
     *                          (DateTime.Hours, DateTime.Minutes,
     *                          DateTime.Seconds, DateTime.All)
     */
    property int fields: DateTime.All

    /*
     * Property: hourMode
     * [int=DateTime.TwentyFourHours] Sets if the time picker should show time in 24-hour clock
     *                          or 12-hour clock format.
     *                          (DateTime.TwentyFourHours, DateTime.TwelveHours)
     */
    property int hourMode: dateTime.hourMode() //DateTime.TwentyFourHours

    /*
     * Property: mode24Hour
     * [bool=false] Sets if the time picker should show time in military time (24h).
     */
    property bool mode24Hour

    /*
     * Property: showSeconds
     * [bool=true] Sets if the time picker should show seconds. Modifying this value
     *             after initialization will uninitialize everything.
     */
    property bool showSeconds

    /*
     * Property: acceptButtonText
     * [string] Optional, the button text for the accept button.
     */
    property alias acceptButtonText: acceptButton.text

    /*
     * Property: rejectButtonText
     * [string] Optional, the button text for the reject button.
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
        objectName: "title"
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

            columns: [hourColumn, minuteColumn, secondColumn, meridiemColumn]
            height: 300
            privateDelayInit: true

            TumblerColumn {
                id: hourColumn
                items: ListModel {
                    id: hourList
                }
                label: "HR"
                selectedIndex: root.hour - ((root.hourMode == DateTime.TwelveHours && root.hour > 11) ? 12 : 0)
                visible: fields & DateTime.Hours
            }

            TumblerColumn {
                id: minuteColumn
                items: ListModel {
                    id: minuteList
                }
                label: "MIN"
                selectedIndex: root.minute
                visible: fields & DateTime.Minutes
            }

            TumblerColumn {
                id: secondColumn
                items: ListModel {
                    id: secondList
                }
                label: "SEC"
                selectedIndex: root.second
                visible: fields & DateTime.Seconds
            }

            TumblerColumn {
                id: meridiemColumn
                items: ListModel {
                    id: meridiemList
                }
                selectedIndex: root.hour > 11 ? 1: 0
                visible: root.hourMode == DateTime.TwelveHours
                privateLoopAround: false
            }
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
        }
        Button {
            id: rejectButton
            onClicked: reject()
            width: (root.width / 2) - 3
            style: ButtonStyle { inverted: true }
        }
    }
    onMode24HourChanged: {
        console.log("The property 'mode24Hour' from TimePickerDialog is deprecated.  Please use 'hourMode' instead.")
        root.hourMode = mode24Hour == true ? DateTime.TwentyFourHours : DateTime.TwelveHours
    }
    onShowSecondsChanged: {
        console.log("The property 'showSeconds' from TimePickerDialog is deprecated.  Please use 'fields' instead.")
        root.fields = showSeconds == true ? DateTime.All : DateTime.Hours | DateTime.Minutes
    }
    onStatusChanged: {
        if (status == DialogStatus.Opening) {
            TH.saveIndex(tumbler);
            if (!internal.initialised)
                internal.initializeDataModels();
        }
    }
    onAccepted: {
        tumbler.privateForceUpdate();
        if (root.hourMode == DateTime.TwelveHours)
            root.hour = hourColumn.selectedIndex + (meridiemColumn.selectedIndex > 0 ? 12 : 0);
        else
            root.hour = hourColumn.selectedIndex;
        root.minute = minuteColumn.selectedIndex;
        root.second = secondColumn.selectedIndex;
    }
    onRejected: {
        TH.restoreIndex(tumbler);
    }
    onHourModeChanged: {
        hourList.clear();
        var tmp = hourColumn.selectedIndex;
        if (root.hourMode == DateTime.TwentyFourHours) {
            tmp = (root.hour < 12 ? tmp : tmp + 12)
            for (var i = 0; i < 24; ++i)
                hourList.append({"value" : (i < 10 ? "0" : "") + i});
        } else {
            tmp = (root.hour < 12 ? tmp : tmp - 12)
            hourList.append({"value" : 12 + ""});
            for (var i = 1; i < 12; ++i)
                hourList.append({"value" : i + ""});
        }
        hourColumn.selectedIndex = -1;
        hourColumn.selectedIndex = tmp;
    }
    onHourChanged: {
        internal.validateTime()
        hourColumn.selectedIndex = root.hour - ((root.hourMode == DateTime.TwelveHours && root.hour > 11) ? 12 : 0)
        meridiemColumn.selectedIndex = root.hour > 11 ? 1: 0
    }
    onMinuteChanged: {
        internal.validateTime()
        minuteColumn.selectedIndex = root.minute
    }
    onSecondChanged: {
        internal.validateTime()
	secondColumn.selectedIndex = root.second
    }

    QtObject {
        id: internal

        property variant initialised: false

        function initializeDataModels() {
            if (root.hourMode == DateTime.TwelveHours) {
                hourList.append({"value" : 12 + ""});
                for (var i = 1; i < 12; ++i)
                    hourList.append({"value" : i + ""});
            }
            for (var i = 0; i < 60; ++i) {
                minuteList.append({"value" : (i < 10 ? "0" : "") + i });
                secondList.append({"value" : (i < 10 ? "0" : "") + i });
            }
            meridiemList.append({"value" : dateTime.amText()});
            meridiemList.append({"value" : dateTime.pmText()});

            tumbler.privateInitialize();
            internal.initialised = true;
        }
        
        function validateTime() {
            root.hour = Math.max(0, Math.min(23, root.hour))
            root.minute = Math.max(0, Math.min(59, root.minute))
            root.second = Math.max(0, Math.min(59, root.second))
        }
    }
}
