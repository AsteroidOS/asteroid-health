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

import "../graphs"

LineGraph {
    id: graph
    property date startTime: new Date()
    property date endTime: new Date()

    onStartTimeChanged: graph.loadGraphData(weightDataLoader.getDataFromTo(startTime,endTime))
    onEndTimeChanged: graph.loadGraphData(weightDataLoader.getDataFromTo(startTime,endTime))

    Component.onCompleted: {
        graph.loadGraphData(weightDataLoader.getDataFromTo(startTime,endTime))
    }
    WeightDataLoader { id: weightDataLoader
    }
}
