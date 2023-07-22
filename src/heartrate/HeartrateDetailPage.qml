/*
 * Copyright (C) 2023 Arseniy Movshev <dodoradio@outlook.com>
 *               2021 Timo Könnecke <github.com/eLtMosen>
 *               2021 Darrel Griët <dgriet@gmail.com>
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
import QtSensors 5.11

import org.asteroid.sensorlogd 1.0

import "../graphs"

Item {
    id: root
    property int currentHr: 0 //we ought to get the last value from hrdataloader - but it currently doesn't do any caching so operation would be a bit slow, and we run the hr sensor when app starts anyway, so we'll ignore that for now
    HrmSensor {
        active: true
        onReadingChanged: {
            currentHr = reading.bpm
        }
    }

    property bool pulseToggle: true
    property int pulseWidth: pulseToggle ? root.height*0.2 : root.height*0.26
    Behavior on pulseWidth { NumberAnimation { duration: pulseAnimationDuration; easing.type: Easing.OutInSine } }

    Timer {
        id: pulseTimer
        interval: 1000 / (currentHr / 30)
        running: currentHr
        repeat: true
        onTriggered: pulseToggle = !pulseToggle
    }
    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.implicitHeight
        Column {
            id: contentColumn
            width: parent.width

            Item { width: parent.width; height: parent.width*0.2}

            // this  chunk of code is modified from https://github.com/AsteroidOS/asteroid-hrm/blob/master/src/main.qml
            Item {
                width: parent.width*0.5
                height: root.height*0.26
                anchors.horizontalCenter: parent.horizontalCenter
                Label {
                    text: currentHr + " bpm"
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                    }
                }

                Text {
                    id: heartPicture
                    anchors {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.right
                    }
                    font.pixelSize: pulseWidth
                    text: "\u2764"
                }
            }
            // end asteroid-hrm code
            Item { width: parent.width; height: parent.width*0.2}

            HrGraph {
                id: graph
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width*0.9
                height: app.height*2/3
                startTime: new Date()
                endTime: new Date()
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width*0.9
                height: width/6
                MouseArea {
                    height: parent.height
                    width: parent.width/3
                    Label {
                        anchors.centerIn: parent
                        text: "3 weeks"
                    }
                    onClicked: {
                        var d = graph.endTime
                        d.setDate(d.getDate() - 20)
                        graph.startTime = d
                    }
                }
                MouseArea {
                    height: parent.height
                    width: parent.width/3
                    Label {
                        anchors.centerIn: parent
                        text: "week"
                    }
                    onClicked: {
                        var d = graph.endTime
                        d.setDate(d.getDate() - 6)
                        graph.startTime = d
                    }
                }
                MouseArea {
                    height: parent.height
                    width: parent.width/3
                    Label {
                        anchors.centerIn: parent
                        text: "day"
                    }
                    onClicked: {
                        graph.startTime = graph.endTime
                    }
                }
            }

            Item { width: parent.width; height: parent.width*0.2}
        }
    }
    PageHeader {
        text: "Heartrate"
    }
}
