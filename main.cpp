#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "workoutmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    WorkoutModel model;

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("myModel", &model);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("GymTracker", "Main");

    return app.exec();
}
