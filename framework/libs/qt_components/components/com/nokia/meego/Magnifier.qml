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

Item {
    id: root

    property alias sourceItem: effectSource.sourceItem
    property alias xCenter: magnifier.xCenter
    property alias yCenter: magnifier.yCenter
    property alias active: magnifier.active
    property real yAdjustment: 0

    visible: magnifier.active
    width: 182
    height: 211
    z: Number.MAX_VALUE

    function __rootElement() {
        var ret = parent
        while (ret.parent) {
            ret = ret.parent
        }
        return ret
    }

    Component.onCompleted: {
        sourceItem = parent;
    }

    ShaderEffectSource {
        id: effectSource
        textureSize: Qt.size((sourceItem.width) * scaleFactor, (sourceItem.height) * scaleFactor);
        hideOriginal: false
        margins: Qt.size(1, 1);

        property real scaleFactor: 1.25
        filtering: ShaderEffectSource.Linear
    }

    ShaderEffectSource {
        id: magnifierFrame
        sourceImage: "/usr/share/themes/blanco/meegotouch/images/theme/basement/meegotouch-virtual-keyboard/meegotouch-seattle-magnifier-frame.png"
        filtering: ShaderEffectSource.Linear
    }

    ShaderEffectSource {
        id: magnifierMask
        sourceImage: "/usr/share/themes/blanco/meegotouch/images/theme/basement/meegotouch-virtual-keyboard/meegotouch-seattle-magnifier-frame-mask.png"
    }

    ShaderEffectItem {
        id: magnifier
        anchors.fill:parent
        active: false

        vertexShader: "
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;
            uniform highp mat4 qt_ModelViewProjectionMatrix;
            uniform highp float xCenter;
            uniform highp float xSize;
            uniform highp float yCenter;
            uniform highp float ySize;
            uniform highp float scaleFactor;
            varying highp vec2 qt_TexCoord0;
            varying highp vec2 qt_TexCoord1;
            void main() {
                qt_TexCoord0.x = xCenter - xSize / (2. * scaleFactor) + xSize * qt_MultiTexCoord0.x / scaleFactor;
                qt_TexCoord0.y = yCenter - ySize / (2. * scaleFactor) + ySize * qt_MultiTexCoord0.y / scaleFactor;
                qt_TexCoord1 = qt_MultiTexCoord0;
                gl_Position = qt_ModelViewProjectionMatrix * qt_Vertex;
            }";

        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            varying highp vec2 qt_TexCoord1;
            uniform lowp sampler2D source;
            uniform lowp sampler2D frame;
            uniform lowp sampler2D mask;
            void main() {
                lowp vec4 frame_c = texture2D(frame, qt_TexCoord1);
                lowp vec4 mask_c = texture2D(mask, qt_TexCoord1);
                lowp vec4 color_c = texture2D(source, qt_TexCoord0);
                bool outsideElement=(qt_TexCoord0.s<0. || qt_TexCoord0.s>1. || qt_TexCoord0.t<0. || qt_TexCoord0.t>1.);
                bool onGlass=(mask_c.a==1.);

                if (outsideElement) {
                    // make white outside the element
                    color_c=vec4(1.,1.,1.,1.);
                } else if (onGlass) {
                    // blend premultiplied texture with pure white (background)
                    color_c = color_c + vec4(1.,1.,1.,1.) * (1.-color_c.a);
                }

                gl_FragColor = (onGlass) ? color_c : frame_c;
        }";

        property real xCenter: 0
        property real yCenter: 0.25
        property real xSize: width / (root.sourceItem.width)
        property real ySize: height / (root.sourceItem.height)
        property real scaleFactor: effectSource.scaleFactor;

        property variant source: effectSource
        property variant frame: magnifierFrame
        property variant mask: magnifierMask
    }
}
