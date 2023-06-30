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

import org.asteroid.health 1.0
import org.asteroid.sensorlogd 1.0

Item {
    id: graph
    width: parent.width*0.9
    anchors.horizontalCenter: parent.horizontalCenter
    property var labelsArr: []
    property var valueDivisionsInterval: 0
    property var valueDivisionsCount: 0
    property var startValueDivision: 0
    property real valuesDelta: hrGraph.relativeMode ? hrGraph.maxValue - hrGraph.minValue : hrGraph.maxValue

    property var timeDivisionsCount: 0
    property var timeDivisionsInterval: 0
    property var startTimeDivision: 0
    property var timeDelta: 0
    property var minTimeSeconds: 0

    function dataLoadingDone() {
        labelsRepeater.model = labelsArr.length
    }
    Component.onCompleted: { // I am so so sorry about this code.
        console.log(typeof hrDataLoader.getTodayData())
        hrGraph.loadGraphData(hrDataLoader.getTodayData())
        console.log("minValue", hrGraph.minValue, "maxValue",hrGraph.maxValue)
        //values divisions
        valueDivisionsInterval = (valuesDelta) >= 50 ? 10 : 5
        valueDivisionsCount = hrGraph.relativeMode ? (Math.ceil(hrGraph.maxValue/valueDivisionsInterval)) - (Math.ceil(hrGraph.minValue/valueDivisionsInterval)) : Math.ceil(hrGraph.maxValue/valueDivisionsInterval) + 1
        startValueDivision = hrGraph.relativeMode ? Math.ceil(hrGraph.minValue/valueDivisionsInterval)*valueDivisionsInterval : 0
        //times divisions
        minTimeSeconds = dateToDaySecs(hrGraph.minTime)
        timeDelta = dateToDaySecs(hrGraph.maxTime) - minTimeSeconds
        timeDivisionsCount = Math.floor(timeDelta/3600) // get number of hours and divide
        timeDivisionsInterval = timeDivisionsCount > 11 ? 4 : 2
        timeDivisionsCount = timeDivisionsCount/timeDivisionsInterval
        startTimeDivision = hrGraph.minTime.getHours() + 1
        labelsRepeater.model = graph.timeDivisionsCount
    }
    HrDataLoader { id: hrDataLoader }
    Item { // labels column
        id: markerParent
        width: parent.width/8
        anchors {
            left: parent.left
            top: hrGraph.top
            bottom: hrGraph.bottom
            topMargin: hrGraph.lineWidth/2
            bottomMargin: anchors.topMargin
        }
        Repeater {
            model: graph.valueDivisionsCount
            delegate: Label {
                anchors.right: parent.right
                property real value: graph.startValueDivision + graph.valueDivisionsInterval*index
                text: value
                font.pixelSize: Dims.w(5)
                y: parent.height - (parent.height)*(value/graph.valuesDelta) - height/2
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    HeartrateGraph {
        id: hrGraph
        anchors {
            left: markerParent.right
            right: parent.right
            top: parent.top
            bottom: labelsRow.top
        }
        relativeMode: false
        lineWidth: 4
    }
    Item { //labels row
        id: labelsRow
        height: Dims.w(5)
        anchors {
            bottom: parent.bottom
            left: hrGraph.left
            right: hrGraph.right
            rightMargin: hrGraph.lineWidth/2
            leftMargin: anchors.rightMargin
        }
        Repeater {
            id: labelsRepeater
            model: 0
            delegate: Label {
                id: dowLabel
                // anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                property var value: graph.startTimeDivision + index*graph.timeDivisionsInterval
                text: value + ":00"
                x: ((value*3600-graph.minTimeSeconds)/graph.timeDelta)*parent.width
                onValueChanged: console.log("value",value, "mintimeseconds", graph.minTimeSeconds, "timeDelta", graph.timeDelta,"x",x,"text",text)
                font.pixelSize: Dims.w(5)
            }
        }
    }
    function dateToDaySecs(date) {
        return (date.getHours()*3600 + date.getMinutes()*60 + date.getSeconds())
    }
}
