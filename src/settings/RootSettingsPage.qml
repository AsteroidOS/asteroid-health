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

import QtQuick
import org.asteroid.controls

import org.asteroid.sensorlogd

Item {
    PageHeader {
        //% "Settings"
        text: qsTrId("id-settings")
        z: 5
    }
    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.implicitHeight
        Column {
            id: contentColumn
            anchors.fill: parent

            Item { width: parent.width; height: parent.width*0.2}

            ListItem {
                //% "UI settings"
                title: qsTrId("id-ui-settings")
                iconName: "ios-settings-outline"
                onClicked: pageStack.push(uiSettingsPage)
            }
            ListItem {
                //% "Logger settings"
                title: qsTrId("id-logger-settings")
                iconName: "ios-settings-outline"
                onClicked: pageStack.push(loggerSettingsPage)
            }

            Item { width: parent.width; height: parent.width*0.2}
        }
    }
    Component {
        id: uiSettingsPage
        UiSettingsPage {
        }
    }
    Component {
        id: loggerSettingsPage
        LoggerSettingsPage {
        }
    }
}
