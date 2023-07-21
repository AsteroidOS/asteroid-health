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
    property date startTime: new Date()
    property date endTime: new Date()

    onStartTimeChanged: stepsGraph.loadGraphData(stepsDataLoader.getDataFromTo(startTime,endTime))
    onEndTimeChanged: stepsGraph.loadGraphData(stepsDataLoader.getDataFromTo(startTime,endTime))

    Component.onCompleted: {
        stepsGraph.loadGraphData(stepsDataLoader.getDataFromTo(startTime,endTime))
    }
    StepsDataLoader { id: stepsDataLoader
        onDataChanged: stepsGraph.loadGraphData(getDataFromTo(startTime,endTime))
    }
    VerticalLabels { // labels column
        id: markerParent
        width: parent.width/8
        startValue: 0
        endValue: stepsGraph.maxValue
        anchors {
            left: parent.left
            top: stepsGraph.top
            bottom: stepsGraph.bottom
            topMargin: stepsGraph.lineWidth/2
            bottomMargin: anchors.topMargin
        }
    }
    LineGraph {
        id: stepsGraph
        anchors {
            left: markerParent.right
            right: parent.right
            top: parent.top
            bottom: labelsRow.top
        }
        relativeMode: false
        lineWidth: 4
    }
    TimeLabels {
        id: labelsRow
        height: Dims.w(5)
        startTime: stepsGraph.minTime / 1000
        endTime: stepsGraph.maxTime / 1000
        anchors {
            bottom: parent.bottom
            left: stepsGraph.left
            right: stepsGraph.right
            rightMargin: stepsGraph.lineWidth/2
            leftMargin: anchors.rightMargin
        }
    }
}
