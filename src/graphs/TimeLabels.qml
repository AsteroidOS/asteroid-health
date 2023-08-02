/*
 * Copyright (C) 2023 Arseniy Movshev <dodoradio@outlook.com>
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
    id: root
    property real startTime: 0
    property real endTime: 0
    property int minLabels: 3 //these min and max numbers of labels are only guidelines for the algorithm, and don't actually set hard limits.
    property int maxLabels: 8
    property int startValueDivision
    onStartTimeChanged: update()
    onEndTimeChanged: update()
    onMinLabelsChanged: update()
    onMaxLabelsChanged: update()
    Component.onCompleted: update()
    function update() {
        listModel.clear()
        var delta = endTime - startTime
        var interval = 0
        if (delta < 60 * maxLabels) { // check 1 minute
            if (delta < 60 * minLabels) {
                interval = 30 //label every 30s otherwise
            } else {
                interval = 60
            }
            startValueDivision = interval * Math.ceil(startTime / interval)
            // iterate and populate the list
            var currentTime = startValueDivision
            var i = 0;
            var date
            while (currentTime < endTime) {
                date = new Date(currentTime*1000)
                var value
                if (date.getMinutes() == 0 | i == 0) {
                    value = date.getHours() + (date.getMinutes() < 10 ? ":0" + date.getMinutes().toString() : date.getMinutes().toString())
                } else if (date.getMinutes() < 10) {
                    value = date.getMinutes() < 10 ? ":0" + date.getMinutes().toString() : date.getMinutes().toString()
                }
                var x  = (currentTime - startTime) / delta
                listModel.append({"value": value, "x": x})
                currentTime = currentTime + interval
                i++
            }

        } else if (delta < 600 * maxLabels) { // check 10 minutes
            if (delta < 600 * minLabels) {
                interval = 300 //label every 5m otherwise
            } else {
                interval = 600
            }
            startValueDivision = interval * Math.ceil(startTime / interval)
            // iterate and populate the list
            var currentTime = startValueDivision
            var i = 0;
            var date
            while (currentTime < endTime) {
                date = new Date(currentTime*1000)
                var value
                if (date.getMinutes() == 0 | i == 0) {
                    value = date.getHours() + (date.getMinutes() < 10 ? ":0" + date.getMinutes().toString() : date.getMinutes().toString())
                } else if (date.getMinutes() < 10) {
                    value = date.getMinutes() < 10 ? ":0" + date.getMinutes().toString() : date.getMinutes().toString()
                }
                var x  = (currentTime - startTime) / delta
                listModel.append({"value": value, "x": x})
                currentTime = currentTime + interval
                i++
            }

        } else if (delta < 7200 * maxLabels) { // check every 2 hours
            if (delta > 3600 * maxLabels) {
                interval = 7200 //label every 2h if 1h doesn't work - this is an ugly workaround so that a full day still gets some sort of divisions
            } else if (delta < 3600 * minLabels) {
                interval = 1800 //label every 30m otherwise
            } else {
                interval = 3600
            }
            startValueDivision = interval * Math.ceil(startTime / interval)
            // iterate and populate the list
            var currentTime = startValueDivision
            var i = 0;
            var date
            while (currentTime < endTime) {
                date = new Date(currentTime*1000)
                var value
                if (date.getMinutes() != 0 | interval != 1800) {
                    value = date.getHours().toString() + "h"
                } else {
                    value = ":" + date.getMinutes()
                }
                var x  = (currentTime - startTime) / delta
                listModel.append({"value": value, "x": x})
                currentTime = currentTime + interval
                i++
            }

        } else if (delta < 86400 * maxLabels) { // check days
            if (delta < 86400 * minLabels) {
                interval = 43200 //label every 12h otherwise
            } else {
                interval = 86400
            }
            startValueDivision = interval * Math.ceil(startTime / interval)
            // iterate and populate the list
            var currentTime = startValueDivision
            var i = 0;
            var date
            while (currentTime < endTime) {
                date = new Date(currentTime*1000)
                var value = date.getDate().toString() /* we should add am and pm here for 12h mode*/
                var x = ((currentTime - startTime) / delta)
                listModel.append({"value": value, "x": x})
                currentTime = currentTime + interval
                i++
            }

        } else if (delta < 604800 * maxLabels) { // check weeks
            interval = 604800
            startValueDivision = interval * Math.ceil(startTime / interval)
            // iterate and populate the list
            var currentTime = startValueDivision
            var i = 0;
            var date
            while (currentTime < endTime) {
                date = new Date(currentTime*1000)
                var value = date.getDate().toString()
                var x = ((currentTime - startTime) / delta)
                listModel.append({"value": value, "x": x})
                currentTime = currentTime + interval
                i++
            }
        } else { // handle months
            console.log("viewing more than several days of data isn't implemented yet. please pester dodoradio about this.")
        }
        // this is slightly crude - we assume that the min and max label numbers will be set in such a way that halving gets us a reasonable interval.
        // we also ignore everything over a number of weeks, as this needs a bit more thought that I don't want to deal with right now. this graph code is stalling too much other development.
    }
    Repeater {
        model: ListModel { id: listModel }
        delegate: Label {
            text: model.value
            font.pixelSize: Dims.w(5)
            x: model.x*root.width - width/2
            verticalAlignment: Text.AlignVCenter
        }
    }
}
