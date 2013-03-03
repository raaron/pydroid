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

Style {
    // Background
    property url background: "image://theme/meegotouch-statusbar-" +
            ((screen.currentOrientation === Screen.Portrait || screen.currentOrientation === Screen.PortraitInverted) ? "portrait" : "landscape") +
            __invertedString + "-background"

    // Fremantle only buttons to replace Harmattan swipe functionality
    property url closeButton: "image://theme/icon-f-statusbar-close"
    property url homeButton:  "image://theme/icon-f-statusbar-home"

    // Default separation between elements
    property int paddingSmall: 6

    // StatusBar default font and colors
    property string defaultFont: theme.constants.Fonts.FONT_FAMILY

    // Indicators fonts and colors
    property string indicatorFont: defaultFont
    property int indicatorFontSize: theme.constants.Fonts.FONT_SMALL
    property string indicatorColor: inverted ?
        theme.constants.Palette.COLOR_STATUSBAR_INVERTED_FOREGROUND :
        theme.constants.Palette.COLOR_STATUSBAR_FOREGROUND

    property int helpFontSize: theme.constants.Fonts.FONT_DEFAULT

    // transitions
    property int visibilityTransitionDuration: 250

    // Fremantle help transitions
    property int showHelpDuration: 1600
    property int helpTransitionDuration: 400

    // Fremantle Battery indicators
    property int batteryLevels: 8
    property int batteryPeriod: 3500 
    property url batteryFrames: "image://theme/icon-s-status-battery"

    // Fremantle Cell indicators
    property url cellStatus: "image://theme/icon-s-status-"
    property url cellRangeMode: "image://theme/icon-s-status-"
    property url cellSignalFrames: "image://theme/icon-s-status-network"

    // Fremantle Network indicators
    property int wlanPeriod: 2000
    property int numberOfWlanFrames: 5
    property int cellPeriod: 2000
    property int numberOfCellFrames: 8
}

