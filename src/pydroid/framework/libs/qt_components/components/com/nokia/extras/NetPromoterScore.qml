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

Rectangle {
    id: root

    // Common public API

    // Input. Set to true if user is signed in to Nokia account.
    // Account email using agreement is shown if user is signed in.
    // Otherwise email input box is shown instead.
    property bool isSignedIn: false

    // Input. Array of localised UI strings:
    //    header - 'Tell us what you think'
    //    question - 'How likely ... ?'
    //    notLikely - 'Not at all\nlikely'
    //    extremelyLikely - 'Extremely\nlikely'
    //    selectScore - 'You must select ...'
    //    commentsInputLabel - 'Please tell us why ...'
    //    contactAgreement - 'You can contact me using ...'
    //    emailInputLabel - 'You can contact me for details...'
    //    emailPlaceholderText - 'Your email address'
    //    emailSipActionKeyLabel - 'Done'
    //    invalidEmail - 'Invalid email address'
    //    legalText - 'Your information will be ...'
    //    submit - 'Submit'

    property variant uiString: QtObject {}

    // Input. Array of horizontal alignments for strings. Accept same
    // values as Text { horizontalAlignment: ... } e.g. Text.AlignLeft, Text.AlignRight and so on.
    // By default all text strings aligned to the left.
    //    header
    //    question
    //    selectScore
    //    commentsInputLabel
    //    contactAgreement
    //    emailInputLabel
    //    invalidEmail
    //    legalText

    property variant uiHorizontalAlignment: QtObject {}

    // Promoter score, between 0 ~ 10
    property alias score: scoreSlider.value

    // True if user touched score slider
    property alias scoreTouched: scoreSlider.touched

    // Optional comments text
    property alias comments: commentsText.text

    // Optional email address
    // emailAddress shall be ignored if isSignedIn is true.
    property alias emailAddress: emailAddressField.text

    // True if user agrees to be contacted using Nokia Account email address.
    // useEmail shall be ignored if isSignedIn is false.
    property alias useEmail: useEmailCheckBox.checked

    // Signal emitted when 'Submit' button is clicked and form passes validation.
    signal submit()

    height: childrenRect.height
    color: "#E0E1E2"

    QtObject {
        id: internal

        property variant defaultValidator:  RegExpValidator{regExp: /.*/}
        property variant emailValidator: RegExpValidator{regExp: /^\w([a-zA-Z0-9._-]+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$/}

        function validateForm() {

            var isValid = true;

            if (!scoreSlider.touched) {
                sliderErrorLabel.visible = true;
                isValid = false;
            }

            if (emailAddress && emailAddress.length > 0) {
                var validator =  internal.emailValidator
                emailAddressField.validator = validator;
                var result = emailAddressField.acceptableInput;
                if (result)emailAddressField.validator = internal.defaultValidator;
                mouseArea.enabled = !result;
                invalidEmailLabel.visible = !result;
                if (!result)isValid = false;
            }

            return isValid;
        }
    }

    Column {
        id: formContent

        anchors {
            left: parent.left
            leftMargin: 16
            right: parent.right
            rightMargin: 16
        }
        height: childrenRect.height

        Item {
            width: parent.width
            height: 16
        }

        Label {
            id: header

            anchors {
                left: parent.left
                leftMargin: 18 - parent.anchors.leftMargin
                right: parent.right
            }

            wrapMode: Text.Wrap
            font.pixelSize: 40
            color: "#282828"
            horizontalAlignment: uiHorizontalAlignment.header || Text.AlignLeft
            text: uiString.header ||
                  "!!Tell us what you think"
        }

        Item {
            width: parent.width
            height: 12
        }

        // Question
        Label {
            width: parent.width
            wrapMode: Text.Wrap
            font.pixelSize: 24
            color: "#282828"
            horizontalAlignment: uiHorizontalAlignment.question || Text.AlignLeft
            text: uiString.question ||
                  "!!How likely are you to recommend this app to a friend or a colleague?"
        }

        Item {
            width: parent.width
            height: 22
        }

        // Numbers
        Row {
            width: parent.width
            height: childrenRect.height

            Label {
                width: parent.width/2
                font.pixelSize: 24
                color: "#282828"
                horizontalAlignment: Text.AlignLeft
                text: "0"
            }
            Label {
                width: parent.width/2
                font.pixelSize: 24
                color: "#282828"
                horizontalAlignment: Text.AlignRight
                text: "10"
            }
        }

        Slider {
            id: scoreSlider
            objectName: "slider_nps_score"

            property bool touched: false
            width: parent.width
            height: 64
            maximumValue: 10
            stepSize: 1
            value: 5
            valueIndicatorVisible: true

            onPressedChanged:  {
                if (pressed) {
                    sliderErrorLabel.visible = false;
                    touched = true;
                }
            }
        }

        // Slider text
        Row {
            width: parent.width
            height: childrenRect.height

            Label {
                width: parent.width/3
                font.pixelSize: 18
                color: "#282828"
                horizontalAlignment: Text.AlignLeft
                text: uiString.notLikely || "!!Not at all \nlikely"
            }

            Item {
                width: parent.width/3
                height: 1
            }

            Label {
                width: parent.width/3
                font.pixelSize: 18
                color: "#282828"
                horizontalAlignment: Text.AlignRight
                text: uiString.extremelyLikely || "!!Extremely \nlikely"
            }
        }

        Item {
            width: parent.width
            height: 8
            visible: sliderErrorLabel.visible
        }

        // Slider error text
        Label {
            id: sliderErrorLabel
            visible: false
            width: parent.width
            font.pixelSize: 18
            color: "#FF3200"
            horizontalAlignment: uiHorizontalAlignment.selectScore || Text.AlignLeft
            text:  uiString.selectScore ||
                   "!!You must select a rating"
        }

        Item {
            width: parent.width
            height: 18
        }

        Image {
            width: parent.width + 16
            x: 8 - parent.anchors.leftMargin
            source: "image://theme/meegotouch-separator-background-horizontal"
            fillMode: Image.TileHorizontally
        }

        Item {
            width: parent.width
            height: 7
        }

        Label {
            width: parent.width
            font.pixelSize: 22
            color: "#505050"
            horizontalAlignment: uiHorizontalAlignment.commentsInputLabel || Text.AlignLeft
            text:  uiString.commentsInputLabel ||
                   "!!Please tell us why you gave this score (optional)"
        }

        SipAttributes {
            id: sipAttributesDefault
        }

        // Comments
        TextArea {
            id: commentsText
            width: parent.width
            height: Math.max(118, implicitHeight)
            platformSipAttributes: sipAttributesDefault
        }

        Item {
            width: parent.width
            height: 16
        }

        Row {
            visible: isSignedIn
            width: parent.width

            spacing: 16

            CheckBox {
                id: useEmailCheckBox
                objectName: "check_nps_email"
                anchors {
                    verticalCenter: parent.verticalCenter
                }
            }

            Label {
                id: description
                anchors {
                    verticalCenter: parent.verticalCenter
                }

                width: parent.width - useEmailCheckBox.width - parent.spacing
                font.pixelSize: 22
                wrapMode: Text.Wrap
                color: "#505050"
                horizontalAlignment: uiHorizontalAlignment.contactAgreement || Text.AlignLeft
                text: uiString.contactAgreement ||
                      "!!You can contact me for details using my Nokia Account e-mail."
            }

        }

        Image {
            width: parent.width + 16
            x: 8 - parent.anchors.leftMargin
            source: "image://theme/meegotouch-separator-background-horizontal"
            fillMode: Image.TileHorizontally
            visible: !isSignedIn
        }

        // Email address
        Column {
            id: emailAddressPane
            width: parent.width
            visible: !isSignedIn

            Item {
                width: parent.width
                height: 7
            }

            Label {
                width: parent.width
                font.pixelSize: 22
                color: "#505050"
                horizontalAlignment: uiHorizontalAlignment.emailInputLabel || Text.AlignLeft
                text: uiString.emailInputLabel ||
                      "!!You can contact me for details (Optional)"
            }

            TextField {
                id: emailAddressField
		objectName: "input_nps_email"
                width: parent.width
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhEmailCharactersOnly | Qt.ImhNoAutoUppercase
                placeholderText: uiString.emailPlaceholderText ||
                                 "!!Your email address"
                platformSipAttributes: SipAttributes {
                    actionKeyLabel: uiString.emailSipActionKeyLabel || ""
                    actionKeyHighlighted: !!uiString.emailSipActionKeyLabel
                }

                Keys.onReturnPressed: {
                    if (internal.validateForm()) {
                        platformCloseSoftwareInputPanel();
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    enabled: false
                    z: 10
                    onClicked: {
                        enabled = false;
                        invalidEmailLabel.visible = false;
                        emailAddressField.forceActiveFocus();
                        emailAddressField.validator = internal.defaultValidator;
                    }
                }

                onTextChanged: {
                    if (invalidEmailLabel.visible) {
                        invalidEmailLabel.visible = false;
                        emailAddressField.validator = internal.defaultValidator;
                    }
                }
            }

            Label {
                id: invalidEmailLabel
                visible: false
                width: parent.width
                font.pixelSize: 18
                color: "#FF3200"
                horizontalAlignment: uiHorizontalAlignment.invalidEmail || Text.AlignLeft
                text: uiString.invalidEmail ||
                      "!!Invalid email address"
            }
        }

        Item {
            width: parent.width
            height: 16
        }

        Label {
            width: parent.width
            font.pixelSize: 22
            color: "#505050"
            wrapMode: Text.Wrap
            horizontalAlignment: uiHorizontalAlignment.legalText || Text.AlignLeft
            text: uiString.legalText ||
                      "!!Your information will be treated according to Nokia privacy policy."
        }

        Item {
            width: parent.width
            height: 16
        }

        Button {
            objectName: "btn_nps_submit"
            width: 322

            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            text: uiString.submit || "!!Submit"

            onClicked: {
                if (internal.validateForm()) {
                    submit()
                }
            }
        }

        Item {
            width: parent.width
            height: 16
        }
    }
}
