TEMPLATE = app

QT += qml quick



SOURCES += main.cpp
RESOURCES += demo.qrc icons/icons.qrc material.qrc

android {
    QT += androidextras svg xml
    DEPENDPATH += $$PWD/../libs/android
    LIBS += -L$$PWD/../libs/android -lmaterial
}

ios:{
  message("iOSSim ----")
  LIBS += -L$$PWD/../libs/iOSSim -lmaterial
}
QML_IMPORT_PATH += $$PWD/Material
message($$QML_IMPORT_PATH)

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat



ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/../libs/android/libmaterial.so
}

HEADERS +=
