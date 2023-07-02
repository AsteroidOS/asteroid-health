/*
 * Copyright (C) 2023 Arseniy Movshev <dodoradio@outlook.com>
 *               2019 Florent Revest <revestflo@gmail.com>
 *               2016 Sylvia van Os <iamsylvie@openmailbox.org>
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
    PageHeader {
        id: title
        text: "Weight"
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

            LabeledActionButton {
                text: "Add record"
                icon: "ios-add-circle-outline"
                width: parent.width
                height: width*0.2
                onClicked: pageStack.push(newRecordDialog)
            }

            Item { width: parent.width; height: parent.width*0.2}
        }
    }
    Component {
        id: newRecordDialog
        Item {
            id: root
            WeightDataLoader {
                id: weightDataLoader
            }

            Row {
                id: weightSelector
                anchors {
                    left: parent.left
                    leftMargin: DeviceInfo.hasRoundScreen ? Dims.w(5) : 0
                    right: parent.right
                    rightMargin: DeviceInfo.hasRoundScreen ? Dims.w(5) : 0
                    verticalCenter: parent.verticalCenter
                }
                height: parent.height*0.6

                CircularSpinner {
                    id: tensSelector
                    height: parent.height
                    width: parent.width/3
                    model: 20
                    showSeparator: false
                    delegate: SpinnerDelegate { text: index }
                }
                CircularSpinner {
                    id: onesSelector
                    height: parent.height
                    width: parent.width/3
                    model: 10
                    showSeparator: true
                    delegate: SpinnerDelegate { text: index }
                }
                CircularSpinner {
                    id: tenthsSelector
                    height: parent.height
                    width: parent.width/3
                    model: 10
                    showSeparator: false
                    delegate: SpinnerDelegate { text: index }
                }
            }

            Component.onCompleted: {
                var currValue = 0;
                tensSelector.currentIndex = Math.floor(currValue/10)
                onesSelector.currentIndex = Math.floor(currValue%10)
                tenthsSelector.currentIndex = Math.floor((currValue*10)%10)
            }

            IconButton {
                iconName: "ios-checkmark-circle-outline"
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    bottomMargin: Dims.iconButtonMargin
                }

                onClicked: {
                    weightDataLoader.addDataPoint(tensSelector.currentIndex*10+onesSelector.currentIndex+tenthsSelector.currentIndex*0.1)
                    pageStack.pop(pageStack.currentLayer)
                }
            }
        }
    }
}
