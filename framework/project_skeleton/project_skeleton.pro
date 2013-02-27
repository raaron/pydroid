QT       += core gui declarative

TARGET = project_skeleton

INCLUDEPATH += $$PWD/build_dependencies/python/include/
LIBS += -L$$PWD/build_dependencies/python -lpython2.7

QMAKE_CXXFLAGS += -std=gnu++0x
SOURCES += main.cpp

HEADERS  += \
    main.h
OTHER_FILES += \
    app/main.py \
    app/view.py \
    app/android_util.py \
    app/view.qml \
    android/src/org/kde/necessitas/ministro/IMinistro.aidl \
    android/src/org/kde/necessitas/ministro/IMinistroCallback.aidl \
    android/src/org/kde/necessitas/origo/QtApplication.java \
    android/src/org/kde/necessitas/origo/QtActivity.java \
    android/src/org/kde/necessitas/origo/GlobalConstants.java \
    android/src/org/kde/necessitas/origo/Utils.java \
    android/version.xml \
    android/res/raw/app.zip \
    android/res/raw/python_27.zip \
    android/res/raw/python_extras_27.zip \
    android/res/values-el/strings.xml \
    android/res/values-rs/strings.xml \
    android/res/values-ro/strings.xml \
    android/res/values-it/strings.xml \
    android/res/values-zh-rCN/strings.xml \
    android/res/values-nl/strings.xml \
    android/res/drawable-hdpi/icon.png \
    android/res/drawable-mdpi/icon.png \
    android/res/values-nb/strings.xml \
    android/res/values-pt-rBR/strings.xml \
    android/res/values-ms/strings.xml \
    android/res/values-fr/strings.xml \
    android/res/drawable/logo.png \
    android/res/drawable/icon.png \
    android/res/values-fa/strings.xml \
    android/res/values-zh-rTW/strings.xml \
    android/res/values/strings.xml \
    android/res/values/libs.xml \
    android/res/layout/splash.xml \
    android/res/values-es/strings.xml \
    android/res/values-ru/strings.xml \
    android/res/values-de/strings.xml \
    android/res/drawable-ldpi/icon.png \
    android/res/values-pl/strings.xml \
    android/res/values-id/strings.xml \
    android/res/values-ja/strings.xml \
    android/res/values-et/strings.xml \
    android/AndroidManifest.xml

# Define pre-build script
mytarget.commands = python $$PWD/scripts/zip_app.py
QMAKE_EXTRA_TARGETS += mytarget
PRE_TARGETDEPS += mytarget