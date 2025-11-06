#pragma once
#include <QWidget>
#include <QTimer>
#include <QDateTime>
#include <QMouseEvent> // <-- Add this include

class SmithChartWidget : public QWidget {
    Q_OBJECT
public:
    explicit SmithChartWidget(QWidget *parent = nullptr);

signals:
    void mouseCoordinates(double x, double y); // <-- Declare the signal

protected:
    void paintEvent(QPaintEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override; // <-- Correct override

private:
    QTimer *timer;
    QDateTime magnetizeStartTime;
    bool magnetizing;
    void startMagnetize();
    void magnetizeStep();
};