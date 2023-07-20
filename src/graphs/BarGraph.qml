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
    property real indicatorLineHeight: 0
    function dataLoadingDone() {
        barsRepeater.model = valuesArr.length
        labelsRepeater.model = labelsArr.length
    }
    VerticalLabels { // labels column
        id: markerParent
        height: parent.height
        width: parent.height*0.1
        anchors {
            left: parent.left
            top: barsRow.top
            bottom: barsRow.bottom
        }
        endValue: barGraph.maxValue
    }
    Rectangle { // indicator line
        id: indicatorLine
        height: 1
        z: 1
        width: barsRepeater.count*(barGraph.width-markerParent.width)/Math.max(barGraph.valuesArr.length,3) - height/2
        anchors.left: markerParent.right
        y: barsRow.height*(1-(barGraph,indicatorLineHeight/barGraph.maxValue))
        visible: barGraph.indicatorLineHeight != 0
    }
    Row { // bars
        id: barsRow
        z: 2
        anchors {
            left: markerParent.right
            top: parent.top
            bottom: labelsRow.top
        }
        Repeater {
            id: barsRepeater
            delegate: Item { //this contains the graph column and positions it correctly
                width: (barGraph.width-markerParent.width)/Math.max(barGraph.valuesArr.length,3)
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
        width: childrenRect.height
        anchors {
            bottom: parent.bottom
            left: barsRow.left
            right: barsRow.right
        }
        Repeater {
            id: labelsRepeater
            delegate: Label {
                width: (barGraph.width-markerParent.width)/barGraph.valuesArr.length
                id: dowLabel
                // anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: barGraph.labelsArr[index]
                font.pixelSize: Dims.w(5)
            }
        }
    }
}
