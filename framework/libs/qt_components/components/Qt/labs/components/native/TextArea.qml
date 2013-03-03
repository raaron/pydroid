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
import Qt.labs.components 1.0 
import "UIConstants.js" as UI
import "EditBubble.js" as Popup
import "TextAreaHelper.js" as TextAreaHelper
import "Magnifier.js" as MagnifierPopup

FocusScope {
    id: root

    // Common public API
    property alias text: textEdit.text
    property alias placeholderText: prompt.text

    property alias font: textEdit.font
    property alias cursorPosition: textEdit.cursorPosition
    property alias readOnly: textEdit.readOnly

    property alias horizontalAlignment: textEdit.horizontalAlignment
    property alias verticalAlignment: textEdit.verticalAlignment

    property alias selectedText: textEdit.selectedText
    property alias selectionStart: textEdit.selectionStart
    property alias selectionEnd: textEdit.selectionEnd

    property alias wrapMode: textEdit.wrapMode
    property alias textFormat: textEdit.textFormat
    // Property enableSoftwareInputPanel is DEPRECATED
    property alias enableSoftwareInputPanel: textEdit.activeFocusOnPress

    property alias inputMethodHints: textEdit.inputMethodHints

    property bool errorHighlight: false

    property Item platformSipAttributes

    property bool platformEnableEditBubble: true

    property Item platformStyle: TextAreaStyle {}
    property alias style: root.platformStyle

    property alias platformPreedit: inputMethodObserver.preedit

    onPlatformSipAttributesChanged: {
        platformSipAttributes.registerInputElement(textEdit)
    }

    function copy() {
        textEdit.copy()
    }

    function paste() {
        textEdit.paste()
    }

    function cut() {
        textEdit.cut()
    }

    // ensure propagation of forceActiveFocus
    function forceActiveFocus() {
        textEdit.forceActiveFocus()
    }

    function select(start, end) {
        textEdit.select(start, end)
    }

    function selectAll() {
        textEdit.selectAll()
    }

    function selectWord() {
        textEdit.selectWord()
    }

    function positionAt(x, y) {
        var p = mapToItem(textEdit, x, y);
        return textEdit.positionAt(p.x, p.y)
    }

    function positionToRectangle(pos) {
        var rect = textEdit.positionToRectangle(pos)
        var point = mapFromItem(textEdit, rect.x, rect.y)
        rect.x = point.x; rect.y = point.y
        return rect;
    }

    function closeSoftwareInputPanel() {
        console.log("TextArea's function closeSoftwareInputPanel is deprecated. Use function platformCloseSoftwareInputPanel instead.")
        platformCloseSoftwareInputPanel()
    }

    function platformCloseSoftwareInputPanel() {
        inputContext.simulateSipClose();
        textEdit.closeSoftwareInputPanel();
    }

    function openSoftwareInputPanel() {
        console.log("TextArea's function openSoftwareInputPanel is deprecated. Use function platformOpenSoftwareInputPanel instead.")
        platformOpenSoftwareInputPanel()
    }

    function platformOpenSoftwareInputPanel() {
        inputContext.simulateSipOpen();
        textEdit.openSoftwareInputPanel();
    }

    Connections {
        target: platformWindow

        onActiveChanged: {
            if(platformWindow.active) {
                if (!readOnly) {
                    if (activeFocus) {
                        platformOpenSoftwareInputPanel();
                        repositionTimer.running = true;
                    }
                }
            } else {
                if (activeFocus) {
                    platformCloseSoftwareInputPanel();
                    Popup.close(textEdit);
                }
            }
        }

        onAnimatingChanged: {
            if (!platformWindow.animating && root.activeFocus) {
                TextAreaHelper.repositionFlickable(contentMovingAnimation);
            }
        }
    }

    // private
    property int __preeditDisabledMask: Qt.ImhHiddenText|                       
                                        Qt.ImhNoPredictiveText|                
                                        Qt.ImhDigitsOnly|                      
                                        Qt.ImhFormattedNumbersOnly|             
                                        Qt.ImhDialableCharactersOnly|           
                                        Qt.ImhEmailCharactersOnly|              
                                        Qt.ImhUrlCharactersOnly 

    implicitWidth: platformStyle.defaultWidth
    implicitHeight: Math.max (UI.FIELD_DEFAULT_HEIGHT,
                              textEdit.height + (UI.FIELD_DEFAULT_HEIGHT - font.pixelSize))

    onActiveFocusChanged: {
        if (activeFocus &&
            !readOnly) {
            platformOpenSoftwareInputPanel();
            repositionTimer.running = true;
        } else if (!activeFocus) {
            if (!readOnly)
                platformCloseSoftwareInputPanel();

            Popup.close(textEdit);            
        }
    }

    BorderImage {
        id: background
	source: errorHighlight?
                platformStyle.backgroundError:
            readOnly?
                platformStyle.backgroundDisabled:
            textEdit.activeFocus? 
                platformStyle.backgroundSelected:
                platformStyle.background

        anchors.fill: parent
        border.left: root.platformStyle.backgroundCornerMargin; border.top: root.platformStyle.backgroundCornerMargin
        border.right: root.platformStyle.backgroundCornerMargin; border.bottom: root.platformStyle.backgroundCornerMargin
    }

    Text {
        id: prompt

        anchors.fill: parent
        anchors.leftMargin: UI.PADDING_XLARGE
        anchors.rightMargin: UI.PADDING_XLARGE
        anchors.topMargin: (UI.FIELD_DEFAULT_HEIGHT - font.pixelSize) / 2
        anchors.bottomMargin: (UI.FIELD_DEFAULT_HEIGHT - font.pixelSize) / 2

        font: root.platformStyle.textFont
        color: root.platformStyle.promptTextColor
        elide: Text.ElideRight

        // opacity for default state
        opacity:  0.0

        states: [
            State {
                name: "unfocused"
                // memory allocation optimization: cursorPosition is checked to minimize displayText evaluations
                when: !root.activeFocus && textEdit.cursorPosition == 0 && !textEdit.text && prompt.text && !textEdit.inputMethodComposing
                PropertyChanges { target: prompt; opacity: 1.0; }
            },
            State {
                name: "focused"
                // memory allocation optimization: cursorPosition is checked to minimize displayText evaluations
                when: root.activeFocus && textEdit.cursorPosition == 0 && !textEdit.text && prompt.text && !textEdit.inputMethodComposing
                PropertyChanges { target: prompt; opacity: 0.6; }
            }
        ]

        transitions: [
            Transition {
                from: "unfocused"; to: "focused";
                reversible: true
                SequentialAnimation {
                    PauseAnimation { duration: 60 }
                    NumberAnimation { target: prompt; properties: "opacity"; duration: 150 }
                }
            },
            Transition {
                from: "focused"; to: "";
                reversible: true
                SequentialAnimation {
                    PauseAnimation { duration:  60 }
                    NumberAnimation { target: prompt; properties: "opacity"; duration: 100 }
                }
            }
        ]
    }

    MouseArea {
        enabled: !textEdit.activeFocus
        z: enabled?1:0
        anchors.fill: parent
        anchors.margins: UI.TOUCH_EXPANSION_MARGIN
        onClicked: {
            if (!textEdit.activeFocus) {
                textEdit.forceActiveFocus();

                // activate to preedit and/or move the cursor
                var preeditDisabled = root.inputMethodHints &                   
                                      root.__preeditDisabledMask
                var injectionSucceeded = false;
                var mappedMousePos = mapToItem(textEdit, mouseX, mouseY);
                var newCursorPosition = textEdit.positionAt(mappedMousePos.x, mappedMousePos.y, TextInput.CursorOnCharacter);
                if (!preeditDisabled
                        && !TextAreaHelper.atSpace(newCursorPosition)
                        && newCursorPosition != textEdit.text.length
                        && !(newCursorPosition == 0 || TextAreaHelper.atSpace(newCursorPosition - 1))) {
                    injectionSucceeded = TextAreaHelper.injectWordToPreedit(newCursorPosition);
                }
                if (!injectionSucceeded) {
                    textEdit.cursorPosition=newCursorPosition;
                }
            }
        }
    }

    TextEdit {
        id: textEdit

        // Exposed for the edit bubble
        property alias preedit: inputMethodObserver.preedit
        property alias preeditCursorPosition: inputMethodObserver.preeditCursorPosition

        x: UI.PADDING_XLARGE
        y: (UI.FIELD_DEFAULT_HEIGHT - font.pixelSize) / 2
        width: parent.width - UI.PADDING_XLARGE * 2

        font: root.platformStyle.textFont
        color: root.platformStyle.textColor
        selectByMouse: false
        selectedTextColor: root.platformStyle.selectedTextColor
        selectionColor: root.platformStyle.selectionColor
	 //{QTQUICK11
        //mouseSelectionMode: TextInput.SelectWords
	 //}
        wrapMode: TextEdit.Wrap
        persistentSelection: false
        focus: true

        function updateMagnifierPosition(posX, posY) {
            var magnifier = MagnifierPopup.popup;
            var cursorHeight = textEdit.positionToRectangle(0,0).height;
            var mappedPos =  mapToItem(magnifier.parent, posX - magnifier.width / 2,
                                       posY - magnifier.height / 2 - cursorHeight - 70);

            magnifier.xCenter = mapToItem(magnifier.sourceItem, posX, 0).x / magnifier.sourceItem.width;
            magnifier.x = mappedPos.x;
            if (-root.mapFromItem(magnifier.__rootElement(), 0,0).y - (posY - cursorHeight) < (magnifier.height / 1.5)) {
                magnifier.yAdjustment = Math.max(0,(magnifier.height / 1.5) + root.mapFromItem(magnifier.__rootElement(), 0,0).y - (posY - cursorHeight));
            } else {
                magnifier.yAdjustment = 0;
            }
            magnifier.yCenter = 1.0 - ((50 + posY - cursorHeight) / root.height);
            magnifier.y = mappedPos.y + magnifier.yAdjustment;
        }

        Component.onDestruction: {
            Popup.close(textEdit);
        }

        onTextChanged: {
            if(root.activeFocus) {
                TextAreaHelper.repositionFlickable(contentMovingAnimation);
            }

            if (textEdit.preedit == "" && Popup.isOpened(textEdit) && !Popup.isChangingInput())
                Popup.close(textEdit);
        }

        Connections {
            target: TextAreaHelper.findFlickable(root.parent)

            onContentYChanged: if (root.activeFocus) TextAreaHelper.filteredInputContextUpdate();
            onContentXChanged: if (root.activeFocus) TextAreaHelper.filteredInputContextUpdate();
            onMovementEnded: inputContext.update();
        }

        Connections {
            target: inputContext

            onSoftwareInputPanelVisibleChanged: {
                if (activeFocus)
                    TextAreaHelper.repositionFlickable(contentMovingAnimation);
            }

            onSoftwareInputPanelRectChanged: {
                if (activeFocus)
                    TextAreaHelper.repositionFlickable(contentMovingAnimation);
            }
        }

        onCursorPositionChanged: {
            if(!MagnifierPopup.isOpened() && activeFocus) {
                TextAreaHelper.repositionFlickable(contentMovingAnimation)
            }

            if (Popup.isOpened(textEdit)) {
                Popup.close(textEdit);
                Popup.open(textEdit);
            }
        }

        onSelectedTextChanged: {
            if (Popup.isOpened(textEdit) && !Popup.isChangingInput()) {
                Popup.close(textEdit);
            }
        }

        InputMethodObserver {
            id: inputMethodObserver

            onPreeditChanged: {
                if (Popup.isOpened(textEdit) && !Popup.isChangingInput()) {
                    Popup.close(textEdit);
                }
            }

        }

        Timer {
            id: repositionTimer
            interval: 350
            onTriggered: TextAreaHelper.repositionFlickable(contentMovingAnimation)
        }

        PropertyAnimation {
            id: contentMovingAnimation
            property: "contentY"
            duration: 200
            easing.type: Easing.InOutCubic
        }

        MouseFilter {
            anchors.fill: parent
            anchors.leftMargin:  UI.TOUCH_EXPANSION_MARGIN - UI.PADDING_XLARGE
            anchors.rightMargin:  UI.TOUCH_EXPANSION_MARGIN - UI.PADDING_MEDIUM
            anchors.topMargin: UI.TOUCH_EXPANSION_MARGIN - (UI.FIELD_DEFAULT_HEIGHT - font.pixelSize) / 2
            anchors.bottomMargin:  UI.TOUCH_EXPANSION_MARGIN - (UI.FIELD_DEFAULT_HEIGHT - font.pixelSize) / 2
            property bool attemptToActivate: false
            property bool pressOnPreedit

            onPressed: {
                var mousePosition = textEdit.positionAt(mouse.x,mouse.y,TextEdit.CursorOnCharacter);
                pressOnPreedit = textEdit.cursorPosition==mousePosition
                var preeditDisabled = root.inputMethodHints &                  
                                      root.__preeditDisabledMask

                attemptToActivate = !pressOnPreedit && !root.readOnly && !preeditDisabled && root.activeFocus && !(mousePosition == 0 || TextAreaHelper.atSpace(mousePosition - 1));
                mouse.filtered = true;
            }

            onHorizontalDrag: {
                // possible pre-edit word have to be committed before selection
                if (root.activeFocus || root.readOnly) {
                    inputContext.reset()                    
                    parent.selectByMouse = true
                    attemptToActivate = false
                }
            }

            onPressAndHold:{
                // possible pre-edit word have to be commited before showing the magnifier
                if ((root.text != "" || inputMethodObserver.preedit != "") && root.activeFocus) {
                    inputContext.reset()
                    attemptToActivate = false
                    parent.selectByMouse = false
                    MagnifierPopup.open(root);
                    var magnifier = MagnifierPopup.popup;
                    parent.cursorPosition = parent.positionAt(mouse.x,mouse.y)
                    parent.updateMagnifierPosition(mouse.x,mouse.y)
                    root.z = Number.MAX_VALUE
                }
            }

            onReleased:{                
                if (MagnifierPopup.isOpened()) {
                    MagnifierPopup.close();
                    TextAreaHelper.repositionFlickable(contentMovingAnimation);
                }

                if (attemptToActivate) {
                    inputContext.reset();
                    var beforeText = textEdit.text;

                    var newCursorPosition = textEdit.positionAt(mouse.x,mouse.y,TextInput.CursorOnCharacter);
                    var injectionSucceeded = false;

                    if (!TextAreaHelper.atSpace(newCursorPosition)                             
                             && newCursorPosition != textEdit.text.length) {
                        injectionSucceeded = TextAreaHelper.injectWordToPreedit(newCursorPosition);
                    }
                    if (injectionSucceeded) {
                        mouse.filtered=true;
                    } else {
                        textEdit.text=beforeText;
                        textEdit.cursorPosition=newCursorPosition;
                    }
                    attemptToActivate = false;
                } else if (!parent.selectByMouse) {
                    if (!pressOnPreedit) inputContext.reset();
                    textEdit.cursorPosition = textEdit.positionAt(mouse.x,mouse.y,TextInput.CursorOnCharacter);
                }
                parent.selectByMouse = false;
            }
            onFinished: {
                if (root.activeFocus && platformEnableEditBubble)
                    Popup.open(textEdit);
            }
            onMousePositionChanged: {
               if (MagnifierPopup.isOpened() && !parent.selectByMouse) {
                    var pos = textEdit.positionAt (mouse.x,mouse.y)
                    var posNextLine = textEdit.positionAt (mouse.x, mouse.y + 1)
                    var posPrevLine = textEdit.positionAt (mouse.x, mouse.y - 1)
                    if (!(Math.abs(posNextLine - pos) > 1 ||
                        Math.abs(posPrevLine - pos) > 1)) {
                        parent.cursorPosition = pos
                    }
                    parent.updateMagnifierPosition(mouse.x,mouse.y);
                }
            }
            onDoubleClicked: {
                // possible pre-edit word have to be committed before selection
                inputContext.reset()
                parent.selectByMouse = true
                attemptToActivate = false
            }
        }
    }



    InverseMouseArea {
        anchors.fill: parent
        anchors.margins: UI.TOUCH_EXPANSION_MARGIN
        enabled: root.activeFocus

        onClickedOutside: {
            if (Popup.isOpened(textEdit) && ((mouseX > Popup.geometry().left && mouseX < Popup.geometry().right) &&
                                           (mouseY > Popup.geometry().top && mouseY < Popup.geometry().bottom))) {
                return;
            }

            root.parent.focus = true;
        }
    }
}
