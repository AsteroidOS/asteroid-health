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
    implicitHeight: contentColumn.implicitHeight
    property var weekday: ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
    Column {
        id: contentColumn
        width: parent.width

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
                    }
                }
                dataLoadingDone()
            }
            indicatorLineHeight: loggerSettings.stepGoalEnabled ? loggerSettings.stepGoalTarget : 0
            indicatorLineColor: interpolateColors(Qt.rgba(1,0,0,1),Qt.rgba(0.06,1,0.11,1),clamp(stepsDataLoader.todayTotal/loggerSettings.stepGoalTarget,0,1))
            onBarClicked: (index)=> {
                var d = new Date()
                d.setDate(d.getDate() - valuesArr.length + 1 + index)
                pageStack.push(detailPage,{"currentDay": d})
            }
        }
    }
    onClicked: pageStack.push(detailPage)
    Component {
        id: detailPage
        StepsDetailPage {}
    }
}
