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

Item {
    id: root
    property date currentDay: new Date()
    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.implicitHeight
        Column {
            id: contentColumn
            width: parent.width

            Item { width: parent.width; height: parent.width*0.2}

            Label {
                anchors {
                    left: parent.left
                    margins: app.width*0.1
                }
                text: graph.startTime.toLocaleDateString()
            }

            StepsLineGraph {
                id: graph
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width*0.9
                height: app.height*2/3
                startTime: root.currentDay
                endTime: root.currentDay
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
        text: "Steps"
    }
}
