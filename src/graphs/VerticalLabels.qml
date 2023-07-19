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
    property real startValue: 0
    property real endValue: 0
    property int minLabels: 3
    property int maxLabels: 8
    property real valueDivisionsInterval: 0
    property real startValueDivision: 0
    property real valuesDelta
    onStartValueChanged: update()
    onEndValueChanged: update()
    onMinLabelsChanged: update()
    onMaxLabelsChanged: update()

    function update() { // this tries to guess how to generate nice looking labels
        valuesDelta = endValue - startValue
        var powTen = Math.pow(10,Math.trunc(Math.log10(valuesDelta)))
        var interval = powTen
        var numLabel = Math.floor(valuesDelta/interval)
        if (numLabel > maxLabels) {
            interval = powTen*2
            numLabel = valuesDelta/interval
            if (numLabel > maxLabels) {
                interval = powTen*5
                numLabel = valuesDelta/interval
                if (numLabel > maxLabels) {
                    interval = powTen*10
                    numLabel = valuesDelta/interval
                }
            }
        }
        if (numLabel < minLabels) {
            interval = powTen/2
            numLabel = valuesDelta/interval
            if (numLabel < minLabels) {
                interval = powTen/5
                numLabel = valuesDelta/interval
                if (numLabel < minLabels) {
                    interval = powTen/10
                    numLabel = valuesDelta/interval
                }
            }
        }
        valueDivisionsInterval = interval
        labelsRepeater.model = Math.round(numLabel) + 1
        startValueDivision = powTen*Math.trunc(startValue/powTen)
    }
    Repeater {
        id: labelsRepeater
        delegate: Label {
            anchors.right: parent.right
            property real value: root.startValueDivision + root.valueDivisionsInterval*index
            text: value > 1000 ? value/1000 + "k" : value
            font.pixelSize: Dims.w(5)
            y: parent.height - (parent.height)*(value/root.valuesDelta) - height/2
            verticalAlignment: Text.AlignVCenter
        }
    }
}
