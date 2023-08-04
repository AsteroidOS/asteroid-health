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
                width: parent.width*0.8
                anchors.horizontalCenter: parent.horizontalCenter
                text: stepsDataLoader.getTodayTotal() ? "You've walked " + stepsDataLoader.todayTotal + " steps today, keep it up!" : "You haven't yet logged any steps today"
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            Item { width: parent.width; height: parent.width*0.1}
            Label {
                anchors {
                    left: parent.left
                    margins: app.width*0.1
                }
                text: "Steps"
            }

            Item { width: parent.width; height: parent.width*0.05}

            BarGraph {
                id: stepsGraph
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width*0.85
                height: app.width*3/5
                property date selectedTime: stepsLineGraph.startTime
                StepsDataLoader {
                    id: stepsDataLoader
                    Component.onCompleted: {
                        triggerDaemonRecording()
                        stepsGraph.loadData()
                    }
                    onDataChanged: stepsGraph.loadData()
                }
                function loadData() {
                    valuesArr = []
                    labelsArr = []
                    colorsArr = []
                    var currDate = new Date()
                    currDate.setDate(currDate.getDate() - 7)
                    for (var i = 0; i < 7; i++) {
                        currDate.setDate(currDate.getDate() + 1)
                        console.log(currDate)
                        var currvalue = stepsDataLoader.getTotalForDate(currDate)
                        if (currvalue > 0 || valuesArr.length > 0) {
                            if (currvalue > maxValue) {
                                maxValue = currvalue
                            }
                            valuesArr.push(currvalue)
                            labelsArr.push(weekday[currDate.getDay()])
                            if(dateCompare(currDate,stepsLineGraph.startTime) && dateCompare(currDate, stepsLineGraph.endTime)) {
                                colorsArr.push("#FFF")
                            } else {
                                colorsArr.push("#AAA")
                            }
                        }
                    }
                    dataLoadingDone()
                }
                indicatorLineHeight: loggerSettings.stepGoalEnabled ? loggerSettings.stepGoalTarget : 0
                onBarClicked: (index)=> {
                    var d = new Date()
                    d.setDate(d.getDate() - valuesArr.length + 1 + index)
                    stepsLineGraph.startTime = d
                    stepsLineGraph.endTime = d
                    loadData()
                }
            }

            Item { width: parent.width; height: parent.width*0.2}

            Label {
                anchors {
                    left: parent.left
                    margins: app.width*0.1
                }
                text: stepsLineGraph.startTime.toLocaleDateString()
            }

            StepsLineGraph {
                id: stepsLineGraph
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
                        var d = stepsLineGraph.endTime
                        d.setDate(d.getDate() - 20)
                        stepsLineGraph.startTime = d
                        stepsGraph.loadData()
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
                        var d = stepsLineGraph.endTime
                        d.setDate(d.getDate() - 6)
                        stepsLineGraph.startTime = d
                        stepsGraph.loadData()
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
                        stepsLineGraph.startTime = stepsLineGraph.endTime
                        stepsGraph.loadData()
                    }
                }
            }

            Item { width: parent.width; height: parent.width*0.2}
        }
    }
    function dateCompare(date1, date2) {
        return (date1.getFullYear() == date2.getFullYear()) && (date1.getMonth() == date2.getMonth()) && (date1.getDate() == date2.getDate())
    }
    PageHeader {
        text: "Steps"
    }
}
