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

var __columns = [];
var __autoColumnWidth = 0;
var __suppressLayoutUpdates = false;

function initialize() {
    // check the width requested by fixed width columns
    var requestedWidth = 0;
    var requestedCount = 0;
    var invisibleCount = 0;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].visible) {
            if (columns[i].width > 0 && !columns[i].privateIsAutoWidth) {
                requestedWidth += columns[i].width;
                requestedCount++;
            }
        } else {
            invisibleCount++;
        }
    }

    // allocate the rest to auto width columns
    if ((columns.length - requestedCount - invisibleCount) > 0) {
        __autoColumnWidth = Math.floor((parent.width - requestedWidth) / (columns.length - requestedCount - invisibleCount));
    }

    for (var i = 0; i < columns.length; i++) {
        var comp = Qt.createComponent("TumblerTemplate.qml");
        var newObj = comp.createObject(tumblerRow);
        if (!columns[i].width || columns[i].privateIsAutoWidth) {
            columns[i].width = __autoColumnWidth;
            columns[i].privateIsAutoWidth = true;
        }
        if (columns[i].label) {
            // enable label for the tumbler
            internal.hasLabel = true;
        }
        newObj.height = root.height;
        newObj.index = i;
        newObj.tumblerColumn = columns[i];
        newObj.widthChanged.connect(layout);
        newObj.visibleChanged.connect(layout);
        __columns.push(newObj);
    }
    privateTemplates = __columns;
}

function clear() {
    var count = __columns.length;
    for (var i = 0; i < count; i++) {
        var tmp = __columns.pop();
        tmp.destroy();
    }
}

function forceUpdate() {
    for (var i = 0; i < columns.length; i++) {
        columns[i].selectedIndex = __columns[i].view.currentIndex;
    }
}

function layout() {
    if (__suppressLayoutUpdates) {
        // guard against onWidthChanged triggering again during this process
        return;
    }
    var requestedWidth = 0;
    var requestedCount = 0;
    var invisibleCount = 0;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].visible) {
            var w = columns[i].width;
            var a = columns[i].privateIsAutoWidth;
            if (!a || (a && w != __autoColumnWidth)) {
                requestedWidth += columns[i].width;
                requestedCount++;
                columns[i].privateIsAutoWidth = false;
            } else {
                columns[i].privateIsAutoWidth = true;
            }
        } else {
            invisibleCount++;
        }
    }

    if ((columns.length - requestedCount - invisibleCount) > 0) {
        __autoColumnWidth = Math.floor((parent.width - requestedWidth) / (columns.length - requestedCount - invisibleCount));
    }

    // guard against onWidthChanged triggering again during this process
    __suppressLayoutUpdates = true;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].privateIsAutoWidth) {
            columns[i].width = __autoColumnWidth;
        }
    }
    __suppressLayoutUpdates = false;
}
