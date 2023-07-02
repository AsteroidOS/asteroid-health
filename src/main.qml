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
import "settings"
import "stepCounter"
import "heartrate"

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

                        StepCounterPreview {
                            width: parent.width
                        }

                        Item { width: parent.width; height: parent.width*0.1}

                        HeartratePreview {
                            width: parent.width
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
        RootSettingsPage {
        }
    }
}
