/*
 * Copyright (C) 2017 Florent Revest <revestflo@gmail.com>
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

#ifndef LINEGRAPH_H
#define LINEGRAPH_H

#include <QQuickPaintedItem>
#include <QPixmap>
#include <QDateTime>
#include <QVector>
#include <QPointF>

class LineGraph : public QQuickPaintedItem
{
    Q_OBJECT

    Q_PROPERTY(float lineWidth READ lineWidth WRITE setLineWidth)
    Q_PROPERTY(QColor lineColor READ lineColor WRITE setLineColor NOTIFY lineColorChanged)
    Q_PROPERTY(int maxValue READ getMaxValue NOTIFY loadingDone)
    Q_PROPERTY(int minValue READ getMinValue NOTIFY loadingDone)
    Q_PROPERTY(QDateTime maxTime READ getMaxTime NOTIFY loadingDone)
    Q_PROPERTY(QDateTime minTime READ getMinTime NOTIFY loadingDone)
    Q_PROPERTY(bool relativeMode READ relative WRITE setRelative)

public:
    Q_INVOKABLE void loadGraphData(QVariant fileDataInput);
    LineGraph();
    void paint(QPainter *painter) override;

signals:
    void loadingDone();
    void lineColorChanged();

public slots:
    float lineWidth();
    void setLineWidth(float width);
    QColor lineColor();
    void setLineColor(QColor color);
    int getMaxValue();
    int getMinValue();
    QDateTime getMaxTime();
    QDateTime getMinTime();
    bool relative();
    void setRelative(bool newRelative);

private:
    void updateBasePixmap();

    float m_lineWidth = 0;
    QColor m_color = QColor(255,255,255);
    QPixmap m_pixmap;
    QList<QPointF> m_filedata;
    bool m_fileLoadStatus;
    int minValue = 0;
    int maxValue = 0;
    int minTime;
    int maxTime;
    bool graphRelative;
};

#endif // LINEGRAPH_H
