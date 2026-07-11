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
import Nemo.Configuration

import org.asteroid.sensorlogd

Item {
    PageHeader {
        //% "UI Settings"
        text: qsTrId("id-ui-settings-title")
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
                //% "Show step count preview"
                text: qsTrId("id-show-step-count-preview")
                checked: stepsPreviewVisible.value
                onCheckedChanged: stepsPreviewVisible.value = checked
            }
            LabeledSwitch {
                width: parent.width
                height: width*0.25
                //% "Show heartrate preview"
                text: qsTrId("id-show-heartrate-preview")
                checked: hrPreviewVisible.value
                onCheckedChanged: hrPreviewVisible.value = checked
            }
            LabeledSwitch {
                width: parent.width
                height: width*0.25
                //% "Show weight preview"
                text: qsTrId("id-show-weight-preview")
                checked: weightPreviewVisible.value
                onCheckedChanged: weightPreviewVisible.value = checked
            }
            Item { width: parent.width; height: parent.width*0.2}
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
    ConfigurationValue {
        id: weightPreviewVisible
        key: "/org/asteroidos/health/ui/weight/showpreview"
        defaultValue: true
    }
}
