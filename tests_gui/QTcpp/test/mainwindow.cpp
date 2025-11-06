#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QLabel>
#include "smithchartwidget.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    // Connect SmithChartWidget's signal to MainWindow's slot
    connect(ui->widget, &SmithChartWidget::mouseCoordinates,
            this, &MainWindow::updateCoordinatesLabel);
}

void MainWindow::updateCoordinatesLabel(double x, double y)
{
        ui->label->setText(QString("Smith Chart Coordinates: x=%1, y=%2").arg(x, 0, 'f', 2).arg(y, 0, 'f', 2));
    
}

MainWindow::~MainWindow()
{
    delete ui;
}
