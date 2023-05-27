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

Application {
    id: app

    centerColor: "#b04d1c"
    outerColor: "#421c0a"

    StepsDataLoader {
        id: stepsDataLoader
        // Component.onCompleted: stepsLabel.text = getTodayData()
    }

    PageHeader {
        id: title
        text: "Overview"
    }

    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.implicitHeight
        Column {
            id: contentColumn
            anchors.fill: parent

            Item { width: parent.width; height: parent.width*0.2}

            Label {
                width: parent.width*0.8
                anchors.horizontalCenter: parent.horizontalCenter
                text: "You've walked " + stepsDataLoader.getTodayData() + " steps today, keep it up!"
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            Item { width: parent.width; height: parent.width*0.1}

            Column { //this is the graph of steps for the past week
                id: stepsGraph
                width: parent.width*0.9
                anchors.horizontalCenter: parent.horizontalCenter
                property var valuesArr: []
                property var maxValue: 0
                Component.onCompleted: {
                    var currDate = new Date()
                    currDate.setDate(currDate.getDate() - 7)
                    for (var i = 0; i < 7; i++) {
                        currDate.setDate(currDate.getDate() + 1)
                        console.log(currDate)
                        var currvalue = stepsDataLoader.getDataForDate(currDate)
                        if (currvalue > 0 || valuesArr.count>0) {
                            if (currvalue > maxValue) {
                                maxValue = currvalue
                            }
                            valuesArr.push(currvalue)
                        }
                        graphRepeater.model = valuesArr.length
                    }
                }
                Label {
                    anchors {
                        left: parent.left
                        margins: app.width*0.1
                    }
                    text: "Steps"
                }
                Row {
                    height: app.height/2
                    anchors {
                        margins: app.width*0.1
                    }
                    Repeater {
                        id: graphRepeater
                        delegate: Item { //this contains the graph column and positions it correctly
                            width: contentColumn.width/7
                            height: stepsGraph.height
                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: parent.width*2/3
                                radius: width/2
                                property int value: stepsGraph.valuesArr[index]
                                height: value/stepsGraph.maxValue*parent.height
                            }
                        }
                    }
                }
            }

            Item { width: parent.width; height: parent.width*0.2}
        }
    }
}
