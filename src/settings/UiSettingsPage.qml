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
import Nemo.Configuration 1.0

import org.asteroid.sensorlogd 1.0

Item {
    PageHeader {
        text: "UI Settings"
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
                width: parent.width
                height: width*0.25
                text: "Show step count preview"
                checked: stepsPreviewVisible.value
                onCheckedChanged: stepsPreviewVisible.value = checked
            }
            LabeledSwitch {
                width: parent.width
                height: width*0.25
                text: "Show heartrate preview"
                checked: hrPreviewVisible.value
                onCheckedChanged: hrPreviewVisible.value = checked
            }
        }
    }

    ConfigurationValue {
        id: stepsPreviewVisible
        key: "/org/asteroidos/health/ui/stepCounter/showpreview"
        defaultValue: true
    }
    ConfigurationValue {
        id: hrPreviewVisible
        key: "/org/asteroidos/health/ui/heartrate/showpreview"
        defaultValue: true
    }
}
