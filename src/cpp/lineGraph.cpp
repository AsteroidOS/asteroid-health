/*
 * Copyright (C) 2023 Arseniy Movshev <dodoradio@outlook.com>
 *               2017 Florent Revest <revestflo@gmail.com>
 * All rights reserved.
 *
 * You may use this file under the terms of BSD license as follows:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the author nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "lineGraph.h"

#include <QPainter>
#include <QDate>
#include <QFile>
#include <QVector>
#include <QSettings>
#include <QStandardPaths>
#include <QPointF>

LineGraph::LineGraph()
{
    setFlag(ItemHasContents, true);
    setAntialiasing(true);
    setRenderTarget(QQuickPaintedItem::FramebufferObject);
}

void LineGraph::paint(QPainter *painter)
{
    if (m_filedata.count() < 2) {
        qDebug() << "not rendering, not enough data";
        return;
    }
    int j = m_filedata.count();
    QPointF points[j];
    if (!graphRelative) {
        minValue = 0;
    }
    float valueDelta = maxValue - minValue;
    float timeDelta = maxTime - minTime;
    float calculatedValue = 0;
    float calculatedTimeSeconds = 0;
    for(int i = 0; i < j; i++) {
        calculatedTimeSeconds = (m_filedata[i].x() - minTime)/timeDelta;
        calculatedValue = 1 - (m_filedata[i].y() - minValue)/valueDelta;
        points[i] = QPointF(m_lineWidth + calculatedTimeSeconds*(width()-2*m_lineWidth), m_lineWidth + calculatedValue*(height()-2*m_lineWidth)); //these +2 -1 are here to make sure that the graph fits within the drawn area, as it will be clipped by qt if it doesn't.
    }
    QPen pen;
    pen.setCapStyle(Qt::RoundCap);
    pen.setJoinStyle(Qt::RoundJoin);
    pen.setWidthF(m_lineWidth);
    pen.setColor(m_color);
    painter->setRenderHints(QPainter::Antialiasing);
    painter->setPen(pen);
    painter->drawPolyline(points,j);
}

void LineGraph::loadGraphData(QVariant fileDataInput) {
    qDebug() << "loadGraphData called";
    QList<QVariant> fileDataAsList = fileDataInput.toList();
    if (fileDataAsList.count() < 1) {
        qDebug() << "no heartrate data to show, failing load";
        return;
    }
    int j = fileDataAsList.count();
    minTime = fileDataAsList[0].toPointF().x();
    maxTime = fileDataAsList[j-1].toPointF().x();
    minValue = fileDataAsList[0].toPointF().y();
    maxValue = minValue;
    m_filedata.clear();
    for(int i = 0; i < j; i++) {
        m_filedata.append(fileDataAsList[i].toPointF());
        if (minValue > m_filedata[i].y()) minValue = m_filedata[i].y();
        if (maxValue < m_filedata[i].y()) maxValue = m_filedata[i].y();
    }
    emit loadingDone();
    update();
}

void LineGraph::setLineColor(QColor color) {
    m_color = color;
    update();
}

QColor LineGraph::lineColor() {
    return m_color;
}

void LineGraph::setLineWidth(float width) {
    m_lineWidth = width;
    update();
}

float LineGraph::lineWidth() {
    return m_lineWidth;
}

int LineGraph::getMaxValue() {
    return maxValue;
}

int LineGraph::getMinValue() {
    return minValue;
}

QDateTime LineGraph::getMaxTime() {
    return QDateTime::fromSecsSinceEpoch(maxTime);
}

QDateTime LineGraph::getMinTime() {
    return QDateTime::fromSecsSinceEpoch(minTime);
}

bool LineGraph::relative() {
    return graphRelative;
}

void LineGraph::setRelative(bool newRelative) {
    graphRelative = newRelative;
}
