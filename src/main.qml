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

import "graphs"

Application {
    id: app

    centerColor: "#0097A6"
    outerColor: "#00060C"

    property var weekday: ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];

    LoggerSettings{
        id: loggerSettings
    }


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
                            }
                            function loadData() {
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

                                //this code figures out graph scaling
                                var powTen = Math.floor(Math.log10(maxValue))
                                divisionsInterval = Math.pow(10,powTen)
                                                    console.log(Math.floor(maxValue/divisionsInterval))
                                maxValue = divisionsInterval*Math.floor(maxValue/divisionsInterval) + (divisionsInterval/5)*Math.ceil((maxValue%divisionsInterval)/(divisionsInterval/5))
                                divisionsCount = Math.floor(maxValue/divisionsInterval) + 1
                                console.log(maxValue,divisionsInterval,divisionsCount)
                                dataLoadingDone()
                            }
                            indicatorLineHeight: loggerSettings.stepGoalEnabled ? loggerSettings.stepGoalTarget : 0
                        }

                        Item { width: parent.width; height: parent.width*0.1}
                        Label {
                            anchors {
                                left: parent.left
                                margins: app.width*0.1
                            }
                            text: "Heartrate"
                        }

                        HrGraph {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width*0.9
                            height: app.height*2/3
                        }

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
