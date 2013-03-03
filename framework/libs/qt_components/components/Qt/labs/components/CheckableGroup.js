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

// This file contains the implementation of CheckableGroup.qml functionality,
// and CheckableGroup root element is identified by 'root'.

var items = [];
var selectedItem = null;
var completed = false;


function add(item) {
    // Add the item, and if it's the case, check it as well.
    items.push(item);
    if (item.checked) {
        check(item);
    } else if (items.length == 1 && completed) {
        // If we are already completed, this enforces the invariant of
        // having always one item checked in the group. For exception
        // case see onCompleted() function.
        check(item);
    }

    // Connect so we know when items left the group or are requesting
    // a different state (check or uncheck). Note that we register
    // passing the item to be the 'this' value when the function
    // is called.
    item.exclusiveGroupChanged.connect(item, onItemExclusiveGroupChange);
    item.checkedChanged.connect(item, onItemCheckedChange);
}

function onItemExclusiveGroupChange() {
    var item = this;
    if (item.checkGroup !== root) {
        remove(item);
    }
}

function onItemCheckedChange() {
    var item = this;

    // In those two cases we know the change was caused by the group, so we can ignore it.
    if ((item === selectedItem && item.checked) ||
        (item !== selectedItem && !item.checked)) {
        return;
    }

    if (item.checked) {
        // A non-selected item was checked, so we do the real check.
        check(item);
    } else if (items.length == 1) {
        // Only one item, and it was unchecked. We have to rollback
        // because it would break the group invariant.
        //
        // NOTE: This cause a glitch in the item.checked variable that
        // goes false then true, however the CheckableGroup.selectedValue
        // remains unchanged. We could avoid this with a custom setter
        // in the 'checked' property of an item.
        item.checked = true;
    } else {
        // The selected item was unchecked, choose another one to check.
        var idx = (items.indexOf(item) + 1) % items.length
        check(items[idx]);
    }
}

function remove(item) {
    // Remove the item from the list
    var idx = items.indexOf(item);
    if (idx == -1) {
        console.log("Error: removing an invalid item.");
        return;
    }
    items.splice(idx, 1);

    item.exclusiveGroupChanged.disconnect(item, onItemExclusiveGroupChange);
    item.checkedChanged.disconnect(item, onItemCheckedChange);

    // If we are removing the selected item, we need to find a
    // replacement to be selected...
    if (selectedItem === item) {
        selectedItem = null;
        if (items.length > 0) {
            var otherIdx = idx % items.length;
            check(items[otherIdx]);
        } else {
            // ...or simply having no selectedValue.
            root.selectedValue = null;
        }
    }
}

/// Select one item, setting the selectedValue in the group
function check(item) {
    // It is important to have the right item in the 'selectedItem'
    // before the changes since we use that to identify that the change
    // was made by us.
    var oldSelectedItem = selectedItem
    selectedItem = item;
    if (oldSelectedItem)
        oldSelectedItem.checked = false;
    item.checked = true;
    root.selectedValue = item.value;
}

function onCompleted() {
    completed = true;

    // When the QML file is loaded, and no items on it had 'checkable: true' (which
    // would be considered in the add() function), then we simply select one of them
    // to enforce the rule of having one item selected.
    //
    // The delayed selection is useful because it allow to declare in the QML file
    // one item as 'checked' and don't see a "glitch" in the selectedValue because
    // another item was added before to the group (and could be selected if this was
    // not delayed).
    if (!selectedItem && items.length > 0) {
        check(items[0]);
    }
}

function clear() {
    var itemsLength = items.length;
    for (var i = 0; i < itemsLength; i++) {
        var item = items[i];
        item.exclusiveGroupChanged.disconnect(item, onItemExclusiveGroupChange);
        item.checkedChanged.disconnect(item, onItemCheckedChange);
        item.exclusiveGroup = null;
    }

    items = [];
    selectedItem = null;
    root.selectedValue = null;
}
