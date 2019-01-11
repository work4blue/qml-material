#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

     QQmlApplicationEngine engine;
      // QPM_INIT(engine);
#if 1 //defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
     // engine.addImportPath("assets:/plugins/");
      engine.addImportPath("qrc:/Material");

      qWarning() << engine.importPathList();

      QString fileInfo = ":/Material/qmldir";

      qWarning() << fileInfo ;
#else
     engine.addImportPath("/Users/pro/Documents/other-workspace/qt-workspace/qml-material/Material");
#endif
       engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}
