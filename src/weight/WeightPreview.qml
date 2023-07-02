/*
 * Copyright (C) 2023 Arseniy Movshev <dodoradio@outlook.com>
 *               2019 Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.15
import org.asteroid.controls 1.0

import org.asteroid.sensorlogd 1.0

import "../graphs"
MouseArea {
    height: column.implicitHeight
    onClicked: pageStack.push(weightDetailPage)
    Column {
        id: column
        anchors.fill: parent
        Label {
            anchors {
                left: parent.left
                margins: app.width*0.1
            }
            text: "Weight"
        }

        Item { width: parent.width; height: parent.width*0.1}

        WeightGraph {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width*0.9
            height: app.height*2/3
            Component.onCompleted: {
                var d = new Date()
                endTime = d
                d.setDate(d.getDate() - 30)
                startTime = d
            }
        }
    }

    Component {
        id: weightDetailPage
        WeightDetailPage {}
    }
}
