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

Item {
    id: barGraph
    anchors.horizontalCenter: parent.horizontalCenter
    property var valuesArr: []
    property var labelsArr: []
    property var maxValue: 0
    property var divisionsInterval: 0
    property var divisionsCount: 0
    function dataLoadingDone() {
        barsRepeater.model = valuesArr.length
        labelsRepeater.model = labelsArr.length
    }
    Item { // labels column
        id: markerParent
        width: parent.width/8
        height: parent.height
        anchors {
            left: parent.left
            top: barsRow.top
            bottom: barsRow.bottom
        }
        Repeater {
            model: barGraph.divisionsCount
            delegate: Label {
                anchors.left: parent.left
                text: barGraph.divisionsInterval*index
                font.pixelSize: Dims.w(5)
                y: parent.height - parent.height*barGraph.divisionsInterval*index/barGraph.maxValue - height/2
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    Row { // bars
        id: barsRow
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            bottom: labelsRow.top
        }
        Repeater {
            id: barsRepeater
            delegate: Item { //this contains the graph column and positions it correctly
                width: barGraph.width/8
                height: parent.height
                Rectangle {
                    id: bar
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width*2/3
                    radius: width/2
                    property int value: barGraph.valuesArr[index]
                    height: (value/barGraph.maxValue)*parent.height
                }
            }
        }
    }
    Row { //labels row
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
                width: barGraph.width/8
                id: dowLabel
                // anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: barGraph.labelsArr[index]
                font.pixelSize: Dims.w(5)
            }
        }
    }
}
