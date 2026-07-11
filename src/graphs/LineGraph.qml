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

import org.asteroid.health
import org.asteroid.sensorlogd

Item {
    id: graph
    function loadGraphData(data) {
        lineGraph_p.loadGraphData(data)
    }

    VerticalLabels { // labels column
        id: markerParent
        width: parent.width/8
        startValue: 0
        endValue: lineGraph_p.maxValue
        anchors {
            left: parent.left
            top: lineGraph_p.top
            bottom: lineGraph_p.bottom
            topMargin: lineGraph_p.lineWidth/2
            bottomMargin: anchors.topMargin
        }
    }
    LineGraph_p {
        id: lineGraph_p
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
        startTime: lineGraph_p.minTime / 1000
        endTime: lineGraph_p.maxTime / 1000
        anchors {
            bottom: parent.bottom
            left: lineGraph_p.left
            right: lineGraph_p.right
            rightMargin: lineGraph_p.lineWidth/2
            leftMargin: anchors.rightMargin
        }
    }
}
