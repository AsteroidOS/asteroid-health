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

Item {
    PageHeader {
        text: "Logger Settings"
        z: 5
    }
    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.implicitHeight
        Column {
            id: contentColumn
            anchors.fill: parent

            Item { width: parent.width; height: parent.width*0.2}

            LabeledSwitch {
                id: stepsEnableSwitch
                width: parent.width
                height: width*0.25
                text: "Log step count"
                Component.onCompleted: checked = loggerSettings.stepCounterEnabled
            }
            IntSelector {
                id: stepsIntervalSelector
                width: parent.width
                height: width*0.25
                value: loggerSettings.stepCounterInterval/60000
                min: 5
                max: 60
                stepSize: 1
                unitMarker: "m"
            }
            LabeledSwitch {
                id: stepsGoalEnableSwitch
                width: parent.width
                height: width*0.25
                text: "Enable steps goal"
                Component.onCompleted: checked = loggerSettings.stepGoalEnabled
            }
            IntSelector {
                id: stepsGoalSelector
                width: parent.width
                height: width*0.25
                value: loggerSettings.stepGoalTarget
                min: 500
                max: 50000
                stepSize: 500
                unitMarker: " steps"
            }
            LabeledSwitch {
                id: hrEnableSwitch
                width: parent.width
                height: width*0.25
                text: "Log heart rate"
                Component.onCompleted: checked = loggerSettings.heartrateSensorEnabled
            }
            IntSelector {
                id: hrIntervalSelector
                width: parent.width
                height: width*0.25
                value: loggerSettings.heartrateSensorInterval/60000
                min: 5
                max: 60
                stepSize: 1
                unitMarker: "m"
            }
            IconButton {
                iconName: "ios-checkmark-circle-outline"
                height: parent.width*0.2
                width: height
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    loggerSettings.stepCounterEnabled = stepsEnableSwitch.checked
                    loggerSettings.stepCounterInterval = stepsIntervalSelector.value*60000
                    loggerSettings.stepGoalEnabled = stepsGoalEnableSwitch.checked
                    loggerSettings.stepGoalTarget = stepsGoalSelector.value
                    loggerSettings.heartrateSensorEnabled = hrEnableSwitch.checked
                    loggerSettings.heartrateSensorInterval = hrIntervalSelector.value*60000
                    loggerSettings.reInitLogger()
                    pageStack.pop(pageStack.currentLayer)
                }
            }
        }
    }
}
