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

/*
   Class: PageIndicator
   Component to indicate the page user is currently viewing.

   A page indicator is a component that shows the number of availabe pages as well as the page the user is
   currently on.  The user can also specify the display type to select the normal/inverted visual.
*/
ImplicitSizeItem {
    id: root

    /*
     * Property: totalPages
     * [int] The total number of pages.  This value should be larger than 0.
     */
    property int totalPages: 0

    /*
     * Property: currentPage
     * [int] The current page the user is on.  This value should be larger than 0.
     */
    property int currentPage: 0

    /*
     * Property: inverted
     * [bool] Specify whether the visual for the rating indicator uses the inverted color.  The value is
     * false for use with a light background and true for use with a dark background.
     */
    property bool inverted: theme.inverted

    implicitWidth: currentImage.width * totalPages + (totalPages - 1) * internal.spacing
    implicitHeight: currentImage.height

    /* private */
    QtObject {
        id: internal

        property int spacing: 8

        property string totalPagesImageSource: inverted ?
                                                 "image://theme/meegotouch-inverted-pageindicator-page" :
                                                 "image://theme/meegotouch-pageindicator-page"
        property string currentPageImageSource: inverted ?
                                                  "image://theme/meegotouch-inverted-pageindicator-page-current" :
                                                  "image://theme/meegotouch-pageindicator-page-current"

        property bool init: true


        function updateUI() {

            if(totalPages <=0) {
                totalPages = 1;
                currentPage = 1;
            } else {
                if(currentPage <=0)
                    currentPage = 1;
                if(currentPage > totalPages)
                    currentPage = totalPages;
            }

            frontRepeater.model = currentPage - 1;
            backRepeater.model = totalPages - currentPage;
        }
    }

    Component.onCompleted: {
        internal.updateUI();
        internal.init = false;
    }

    onTotalPagesChanged: {
        if(!internal.init)
            internal.updateUI();
    }

    onCurrentPageChanged: {
        if(!internal.init)
            internal.updateUI();
    }

    Row {
        Repeater {
             id: frontRepeater

             Item {
                 height: currentImage.height
                 width:  currentImage.width + internal.spacing

                 Image {
                     source: internal.totalPagesImageSource
                 }
             }
         }

         Image {
             id: currentImage
             source:  internal.currentPageImageSource
         }

         Repeater {
             id: backRepeater

             Item {
                 height: currentImage.height
                 width:  currentImage.width + internal.spacing

                 Image {
                     source: internal.totalPagesImageSource
                     anchors.right: parent.right
                 }
             }
         }
    }
}
