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
import "TumblerIndexHelper.js" as TH

/*
   Class: DatePickerDialog
   Dialog that shows a date picker.
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
     * Property: year
     * [int] The displayed year.
     */
    property int year: dateTime.currentYear()

    /*
     * Property: month
     * [int] The displayed month.
     */
    property int month: 1

    /*
     * Property: day
     * [int] The displayed day.
     */
    property int day: 1

    /*
     * Property: minimumYear
     * [int] Optional, the minimum year shown on the tumbler. This property should
     *       only be set once during construction. If the value is not specified,
     *       it is default to current year - 1.
     */
    property int minimumYear: dateTime.currentYear() - 1

    /*
     * Property: maximumYear
     * [int] Optional, the maximum year shown on the tumbler. This property should
     *       only be set once during construction. If the value is not specified,
     *       it is default to current year + 20.
     */
    property int maximumYear: dateTime.currentYear() + 20

    /*
     * Property: acceptButtonText
     * [string] Optional, the button text for the accept button.
     */
    property alias acceptButtonText: confirmButton.text

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
        id: dialogContent
        height: 300
        width: parent.width

        Tumbler {
            id: tumbler

            function _handleTumblerChanges(index) {
                if (index == 1 || index == 2) {
                    var curYear = yearColumn.selectedIndex + yearList.get(0).value;
                    var curMonth = monthColumn.selectedIndex + 1;

                    var d = dateTime.daysInMonth(curYear, curMonth);
                    if (dayColumn.selectedIndex >= d)
                        dayColumn.selectedIndex = d - 1
                    while (dayList.count > d)
                        dayList.remove(dayList.count - 1)
                    while (dayList.count < d)
                        dayList.append({"value" : dayList.count + 1})
                }
            }

            columns:  [dayColumn, monthColumn, yearColumn]
            onChanged: {
                _handleTumblerChanges(index);
            }
            height: 300
            privateDelayInit: true
            
            TumblerColumn {
                id: dayColumn
                items: ListModel {
                    id: dayList
                }
                label: "DAY"
                selectedIndex: root.day - (root.day > 0 ?  1 : 0)
            }
    
            TumblerColumn {
                id: monthColumn
                items: ListModel {
                    id: monthList
                }
                label: "MONTH"
                selectedIndex: root.month - (root.month > 0 ?  1 : 0)
            }
    
            TumblerColumn {
                id: yearColumn
                items: ListModel {
                    id: yearList
                }
                label: "YEAR"
                selectedIndex: yearList.length > 0 ? internal.year - yearList.get(0).value : 0
            }
        }
    }
    buttons: Row {
        height: 56
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 6
        Button {
            id: confirmButton
            text: "CONFIRM"
            onClicked: accept()
            width: (root.width / 2) - 3
            style: ButtonStyle { inverted: true }
        }
        Button {
            id: rejectButton
            text: "CANCEL"
            onClicked: reject()
            width: (root.width / 2) - 3
            platformStyle: ButtonStyle { inverted: true }
        }
    }
    onMinimumYearChanged: {
        if (!internal.surpassUpdate) {
            internal.year = root.year
            internal.minYear = root.minimumYear
            
            if (internal.minYear < 0)
                internal.minYear = dateTime.currentYear() - 1;
            else if (internal.minYear > root.maximumYear)
                internal.minYear = root.maximumYear;

            internal.updateYearList()
            internal.validateDate()
            internal.year = internal.year < internal.minYear ? internal.minYear : 
                            (internal.year > root.maximumYear ? root.maximumYear :internal.year) 
        }
    }
    onMaximumYearChanged: {
        internal.minYear = root.minimumYear
        
        if (root.maximumYear < 0)
            root.maximumYear = dateTime.currentYear() + 20;
        else if (root.maximumYear < internal.minYear)
            root.maximumYear = internal.minYear;

        internal.updateYearList()
        internal.validateDate()
        internal.year = internal.year > root.maximumYear ? root.maximumYear : 
                        (internal.year < internal.minYear ? internal.minYear : internal.year)
        if (internal.minYear < 0)
            root.minimumYear = dateTime.currentYear() - 1
    }
    onStatusChanged: {
        if (status == DialogStatus.Opening) {
            TH.saveIndex(tumbler);
            if (!internal.initialized)
                internal.initializeDataModels();
            if (internal.year > 0)
                yearColumn.selectedIndex = internal.year - yearList.get(0).value;
            tumbler._handleTumblerChanges(2);
            dayColumn.selectedIndex = root.day - 1;
        }
        if (status == DialogStatus.Closing) {
            internal.surpassUpdate = true
            if (internal.surpassUpdate) {
                root.year = internal.year
                root.minimumYear = internal.minYear
            }
            internal.surpassUpdate = false
        }
    }
    onDayChanged: {
        internal.validateDate()
        if (dayColumn.items.length > root.day - 1)
            dayColumn.selectedIndex = root.day - 1
    }
    onMonthChanged: {
        internal.validateDate()
        monthColumn.selectedIndex = root.month - 1
    }
    onYearChanged: {
        if (!internal.surpassUpdate) {
            internal.year = root.year
            internal.validateDate()
            internal.year = internal.year < internal.minYear ? internal.minYear : 
                                  (internal.year > root.maximumYear ? root.maximumYear : internal.year)
        
            if (internal.initialized)
                yearColumn.selectedIndex = internal.year - yearList.get(0).value  
        }
    }
    onAccepted: {
        tumbler.privateForceUpdate();
        root.year = yearColumn.selectedIndex + yearList.get(0).value;
        root.month = monthColumn.selectedIndex + 1;
        root.day = dayColumn.selectedIndex + 1;
    }
    onRejected: {
        TH.restoreIndex(tumbler);
    }

    QtObject {
        id: internal

        property variant initialized: false
        property int year
        property int minYear
        property bool surpassUpdate: false

        function initializeDataModels() {
            var currentYear = new Date().getFullYear();
            minimumYear = minimumYear ? minimumYear : currentYear - 1;
            maximumYear = maximumYear ? maximumYear : currentYear + 20;

            for (var y = minimumYear; y <= maximumYear; ++y)
                yearList.append({"value" : y}) // year

            var nDays = dateTime.daysInMonth(internal.year, root.month);
            for (var d = 1; d <= nDays; ++d)
                dayList.append({"value" : d})  // day
            for (var m = 1; m <= 12; ++m)
                monthList.append({"value" : dateTime.shortMonthName(m)});

            tumbler.privateInitialize();
            internal.initialized = true;
        }

        function updateYearList() {
            if (internal.initialized) {
                var tmp = yearColumn.selectedIndex;
                yearList.clear();
                for (var i = internal.minYear; i <= root.maximumYear; ++i)
                    yearList.append({"value" : i})
                if (tmp < yearList.count) {
                    yearColumn.selectedIndex = 0;
                    yearColumn.selectedIndex = tmp;
                }
            }
        }

        function validateDate() {
            if (internal.year < 1){
                internal.year = new Date().getFullYear()
                if (maximumYear < internal.year)
                    root.maximumYear = dateTime.currentYear() + 20;
                if (minimumYear > internal.year)
                    internal.minYear = dateTime.currentYear() - 1;
            }
            
            root.month = Math.max(1, Math.min(12, root.month))
            var d = dateTime.daysInMonth(internal.year, root.month);
            root.day = Math.max(1, Math.min(d, root.day))
        }
    }
}
