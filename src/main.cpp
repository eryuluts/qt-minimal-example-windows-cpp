#include <QtWidgets/QApplication>
#include <QtWidgets/QMainWindow>

int WinMain(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QMainWindow window(NULL);
    window.show();
    app.exec();
}