#include "smithchartwidget.h"
#include <QPainter>
#include <cmath>
#include <QPushButton>
#include <QTimer>
#include <QCursor>
#include <QApplication>
#include <QHBoxLayout>
#include <QMouseEvent> // <-- Add this include

SmithChartWidget::SmithChartWidget(QWidget *parent)
    : QWidget(parent)
{
    setMinimumSize(400, 400);

    QPushButton *magnetizeBtn = new QPushButton("Magnetize Mouse", this);
    magnetizeBtn->setGeometry(10, 10, 150, 30);

    timer = new QTimer(this);
    connect(magnetizeBtn, &QPushButton::clicked, this, &SmithChartWidget::startMagnetize);
    connect(timer, &QTimer::timeout, this, &SmithChartWidget::magnetizeStep);
    magnetizing = false;
}

void SmithChartWidget::startMagnetize() {
    magnetizeStartTime = QDateTime::currentDateTime();
    magnetizing = true;
    timer->start(10); // 10 ms interval
}

void SmithChartWidget::magnetizeStep() {
    if (!magnetizing) return;
    if (magnetizeStartTime.msecsTo(QDateTime::currentDateTime()) > 3000) {
        timer->stop();
        magnetizing = false;
        return;
    }

    QPoint globalCenter = mapToGlobal(QPoint(width()/2, height()/2));
    QPoint mousePos = QCursor::pos();

    // Only magnetize if mouse is not on the horizontal line (y differs from center)
    if (mousePos.y() != globalCenter.y()) {
        QCursor::setPos(mousePos.x(), globalCenter.y());
    }
}

void SmithChartWidget::paintEvent(QPaintEvent *)
{
    QPainter painter(this);
    painter.setRenderHint(QPainter::Antialiasing);
    int w = width();
    int h = height();
    double radius = 0.4 * std::min(w, h);
    double centerX = w / 2.0;
    double centerY = h / 2.0;

    // Draw outer circle (|rho|=1)
    painter.setPen(QPen(Qt::black, 2));
    painter.drawEllipse(QPointF(centerX, centerY), radius, radius);

    // Draw horizontal axis
    painter.setPen(QPen(Qt::gray, 1, Qt::DashLine));
    painter.drawLine(QPointF(centerX - radius, centerY), QPointF(centerX + radius, centerY));

    // Draw a few constant resistance circles (impedance)
    painter.setPen(QPen(Qt::red, 1));
    double paramR[] = {0.2, 0.5, 1, 2, 5};
    int N = 200;
    for (double r : paramR) {
        QPolygonF poly;
        for (int i = 0; i < N; ++i) {
            double x = 0.01 * std::pow(10000.0, (double)i / (N - 1));
            double denom = (r + 1) * (r + 1) + x * x;
            double rhoRe = (r * r + x * x - 1) / denom;
            double rhoIm = (2 * x) / denom;
            double px = centerX + radius * rhoRe;
            double py = centerY - radius * rhoIm;
            poly << QPointF(px, py);
        }
        for (int i = N - 1; i >= 0; --i) {
            double x = -0.01 * std::pow(10000.0, (double)i / (N - 1));
            double denom = (r + 1) * (r + 1) + x * x;
            double rhoRe = (r * r + x * x - 1) / denom;
            double rhoIm = (2 * x) / denom;
            double px = centerX + radius * rhoRe;
            double py = centerY - radius * rhoIm;
            poly << QPointF(px, py);
        }
        painter.drawPolyline(poly);
    }
}

void SmithChartWidget::mouseMoveEvent(QMouseEvent *event)
{
    // Calculate normalized coordinates for Smith Chart
    int w = width();
    int h = height();
    double radius = 0.4 * std::min(w, h);
    double centerX = w / 2.0;
    double centerY = h / 2.0;
    double x = (event->position().x() - centerX) / radius;
    double y = -(event->position().y() - centerY) / radius;

    // Only emit if inside the circle
    if ((x * x + y * y) <= 1.0) {
        emit mouseCoordinates(x, y);
    }

    QWidget::mouseMoveEvent(event);
}