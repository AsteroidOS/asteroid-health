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

    centerColor: "#0097A6"
    outerColor: "#00060C"

    property var weekday: ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];


    LayerStack {
        id: pageStack
        anchors.fill: parent
        firstPage: Component {
            Item {
                PageHeader {
                    id: title
                    text: "Overview"
                    z: 5
                }

                Flickable {
                    z: 1
                    anchors.fill: parent
                    contentHeight: contentColumn.implicitHeight
                    Column {
                        id: contentColumn
                        anchors.fill: parent

                        Item { width: parent.width; height: parent.width*0.2}

                        Label {
                            width: parent.width*0.8
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: stepsDataLoader.getTodayData() ? "You've walked " + stepsDataLoader.getTodayData() + " steps today, keep it up!" : "You haven't yet logged any steps today"
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                        }

                        Item { width: parent.width; height: parent.width*0.1}

                        Column { //this is the graph of steps for the past week
                            id: stepsGraph
                            width: parent.width*0.9
                            anchors.horizontalCenter: parent.horizontalCenter
                            property var valuesArr: []
                            property var labelsArr: []
                            property var maxValue: 0
                            property var divisionsInterval: 0
                            property var divisionsCount: 0
                            StepsDataLoader {
                                id: stepsDataLoader
                                Component.onCompleted: {
                                    triggerDaemonRecording()
                                    stepsGraph.loadData()
                                }
                            }
                            function loadData() {
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
                                        labelsArr.push(weekday[currDate.getDay()])
                                    }
                                }

                                //this code figures out graph scaling
                                var powTen = Math.floor(Math.log10(maxValue))
                                divisionsInterval = Math.pow(10,powTen)
                                                    console.log(Math.floor(maxValue/divisionsInterval))
                                maxValue = divisionsInterval*Math.floor(maxValue/divisionsInterval) + (divisionsInterval/5)*Math.ceil((maxValue%divisionsInterval)/(divisionsInterval/5))
                                divisionsCount = Math.floor(maxValue/divisionsInterval) + 1
                                console.log(maxValue,divisionsInterval,divisionsCount)
                                // now update the repeater so it reloads the data. for some reason a normal qml binding doesn't do it here.
                                barsRepeater.model = valuesArr.length
                                labelsRepeater.model = valuesArr.length
                            }
                            Label {
                                anchors {
                                    left: parent.left
                                    margins: app.width*0.1
                                }
                                text: "Steps"
                            }
                            Item {
                                height: app.height/2
                                anchors {
                                    margins: app.width*0.05
                                    left: parent.left
                                    right: parent.right
                                }
                                Item {
                                    id: markerParent
                                    width: parent.width/8
                                    height: parent.height
                                    anchors {
                                        left: parent.left
                                        top: barsRow.top
                                        bottom: barsRow.bottom
                                    }
                                    Repeater {
                                        model: stepsGraph.divisionsCount
                                        delegate: Label {
                                            anchors.right: parent.right
                                            text: stepsGraph.divisionsInterval*index
                                            font.pixelSize: Dims.w(5)
                                            y: parent.height - parent.height*stepsGraph.divisionsInterval*index/stepsGraph.maxValue - height/2
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                    }
                                }
                                Row {
                                    id: barsRow
                                    anchors {
                                        horizontalCenter: parent.horizontalCenter
                                        top: parent.top
                                        bottom: labelsRow.top
                                    }
                                    Repeater {
                                        id: barsRepeater
                                        delegate: Item { //this contains the graph column and positions it correctly
                                            width: stepsGraph.width/8
                                            height: parent.height
                                            Rectangle {
                                                id: bar
                                                anchors.bottom: parent.bottom
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                width: parent.width*2/3
                                                radius: width/2
                                                property int value: stepsGraph.valuesArr[index]
                                                height: (value/stepsGraph.maxValue)*parent.height
                                            }
                                        }
                                    }
                                }
                                Row {
                                    id: labelsRow
                                    height: Dims.w(5)
                                    anchors {
                                        bottom: parent.bottom
                                        left: barsRow.left
                                        right: barsRow.right
                                    }
                                    Repeater {
                                        id: labelsRepeater
                                        delegate: Label {
                                            width: stepsGraph.width/8
                                            id: dowLabel
                                            // anchors.horizontalCenter: parent.horizontalCenter
                                            horizontalAlignment: Text.AlignHCenter
                                            text: stepsGraph.labelsArr[index]
                                            font.pixelSize: Dims.w(5)
                                        }
                                    }
                                }
                            }
                        }

                        Item { width: parent.width; height: parent.width*0.1}
                        ListItem {
                            title: "Settings"
                            iconName: "ios-settings-outline"
                            onClicked: pageStack.push(settingsPage)
                        }

                        Item { width: parent.width; height: parent.width*0.2}
                    }
                }
            }
        }
    }
    Component {
        id: settingsPage
        SettingsPage {
        }
    }
}
