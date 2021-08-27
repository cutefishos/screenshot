/*
 * Copyright (C) 2021 CutefishOS Team.
 *
 * Author:     Reion Wong <reionwong@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import FishUI 1.0 as FishUI

Item {
    id: control

    property rect cropRect
    property bool cropping: false

    Image {
        id: image
        anchors.fill: parent
        source: "file:///tmp/cutefish-screenshot.png"
        asynchronous: true

        Rectangle {
            id: dimRect
            anchors.fill: parent
            color: "#000"
            opacity: 0.5
        }
    }

    Rectangle {
        id: selectLayer

        property int newX: 0
        property int newY: 0

        z: 999
        height: 0
        width: 0
        x: 0
        y: 0
        visible: false
        clip: true

        function reset() {
            selectLayer.x = 0
            selectLayer.y = 0
            selectLayer.newX = 0
            selectLayer.newY = 0
            selectLayer.visible = false
            selectLayer.width = 0
            selectLayer.height = 0
        }

        Image {
            source: "file:///tmp/cutefish-screenshot.png"
            width: control.width
            height: control.height
            x: -selectLayer.x
            y: -selectLayer.y
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.width: 2
            border.color: FishUI.Theme.highlightColor
        }

        DragHandler {
            target: selectLayer

            xAxis.enabled: true
            xAxis.minimum: control.x
            xAxis.maximum: control.width - selectLayer.width

            yAxis.enabled: true
            yAxis.minimum: control.y
            yAxis.maximum: control.height - selectLayer.height
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeAllCursor
        }
    }

    Rectangle {
        id: sizeToolTip
        visible: selectLayer.visible && selectLayer.width > 1 && selectLayer.height > 1

        width: sizeLabel.implicitWidth + FishUI.Units.largeSpacing
        height: sizeLabel.implicitHeight + FishUI.Units.largeSpacing

        x: selectLayer.x
        y: selectLayer.y - sizeToolTip.height - FishUI.Units.smallSpacing

        radius: FishUI.Theme.smallRadius

        color: Qt.rgba(FishUI.Theme.backgroundColor.r,
                       FishUI.Theme.backgroundColor.g,
                       FishUI.Theme.backgroundColor.b, 0.8)

        Label {
            id: sizeLabel
            anchors.centerIn: parent
            text: "%1 * %2".arg(parseInt(selectLayer.width)).arg(parseInt(selectLayer.height))
        }
    }

    Rectangle {
        id: tools

        width: toolsLayout.implicitWidth + FishUI.Units.largeSpacing
        height: 36 + FishUI.Units.smallSpacing

        visible: sizeToolTip.visible

        z: 999
        x: selectLayer.x + selectLayer.width - tools.width
        y: selectLayer.y + selectLayer.height + tools.height >= control.height ? selectLayer.y - tools.height - FishUI.Units.smallSpacing
                                                                               : selectLayer.y + selectLayer.height + FishUI.Units.smallSpacing

        radius: FishUI.Theme.smallRadius

        color: FishUI.Theme.backgroundColor

        MouseArea {
            anchors.fill: parent
        }

        RowLayout {
            id: toolsLayout
            anchors.fill: parent

            anchors.leftMargin: FishUI.Units.smallSpacing
            anchors.rightMargin: FishUI.Units.smallSpacing
            anchors.topMargin: FishUI.Units.smallSpacing / 2
            anchors.bottomMargin: FishUI.Units.smallSpacing / 2

            ImageButton {
                iconMargins: FishUI.Units.largeSpacing
                size: 36
                source: "qrc:/images/save.svg"
                onClicked: view.saveFile(Qt.rect(selectLayer.x * Screen.devicePixelRatio,
                                                 selectLayer.y * Screen.devicePixelRatio,
                                                 selectLayer.width * Screen.devicePixelRatio,
                                                 selectLayer.height * Screen.devicePixelRatio))
            }

            ImageButton {
                iconMargins: FishUI.Units.largeSpacing
                size: 36
                source: "qrc:/images/cancel.svg"
                onClicked: view.quit()
            }

            ImageButton {
                iconMargins: FishUI.Units.largeSpacing
                size: 36
                source: "qrc:/images/ok.svg"
            }
        }
    }

    // Global
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.CrossCursor

        onPressed: {
            selectLayer.visible = true
            selectLayer.x = mouseX
            selectLayer.y = mouseY
            selectLayer.newX = mouseX
            selectLayer.newY = mouseY
            selectLayer.width = 0
            selectLayer.height = 0
        }

        onPositionChanged: {
            if (!mouseArea.pressed)
                return

            if (mouseX >= selectLayer.newX) {
                selectLayer.width = mouseX < (control.x + control.width) ? (mouseX - selectLayer.x) : selectLayer.width
            } else {
                selectLayer.x = mouseX < control.x ? control.x : mouseX
                selectLayer.width = selectLayer.newX - selectLayer.x
            }

            if (mouseY >= selectLayer.newY) {
                selectLayer.height = mouseY < (control.y + control.height) ? (mouseY - selectLayer.y) : selectLayer.height
            } else {
                selectLayer.y = mouseY < control.y ? control.y : mouseY
                selectLayer.height = selectLayer.newY - selectLayer.y
            }
        }
    }
}
