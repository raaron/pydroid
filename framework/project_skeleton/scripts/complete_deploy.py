#!/usr/bin/python

# QtCreator "Run" equivalent. Use this script for the initial deployment and
# for later deployments if you made changes outside the APP_DIR or if you do
# not have a rooted device. Otherwise fast_deploy.py is much faster!

# Complete new installation of the project on the device without the GUI of
# QtCreator. Zips the current version of the PySide project before deploying
# and first uninstalls the previous version of the app if it exists.

import os
import subprocess

import zip_app
import zip_libs
from script_utils import PROJECT_DIR
from script_utils import get_app_name, get_package_name, get_adb_path
from script_utils import get_necessitas_dir, get_arm_version, restart_app

QT_482_DIR = os.path.join(get_necessitas_dir(), "Android", "Qt", "482")
QMAKE_PATH = os.path.join(QT_482_DIR, "armeabi-%s" % get_arm_version(),
                          "bin", "qmake")

PRO_FILE = os.path.join(PROJECT_DIR, "%s.pro" % get_app_name())
BUILD_DIR = os.path.join(PROJECT_DIR, "build")
INSTALL_ROOT = os.path.join(PROJECT_DIR, "android")
NECESSITAS_QT_DIR = os.path.join(get_necessitas_dir(), "QtCreator", "Qt")
QT_PLUGIN_DIR = os.path.join(NECESSITAS_QT_DIR, "plugins")
SDK_DIR = os.path.join(get_necessitas_dir(), "android-sdk")
APK_PATH = os.path.join(INSTALL_ROOT, "bin", "%s-debug.apk" % get_app_name())


def export_environment_variables():
    """Export all necessary variables for the build."""

    os.environ["ANDROID_NDK_HOST"] = "linux-x86"
    os.environ["ANDROID_NDK_PLATFORM"] = "android-14"
    os.environ["ANDROID_NDK_ROOT"] = os.path.join(get_necessitas_dir(),
                                                  "android-ndk")

    os.environ["ANDROID_NDK_TOOLCHAIN_PREFIX"] = "arm-linux-androideabi"
    os.environ["ANDROID_NDK_TOOLCHAIN_VERSION"] = "4.4.3"
    os.environ["ANDROID_NDK_TOOLS_PREFI"] = "arm-linux-androideabi"
    os.environ["ANDROID_HOME"] = SDK_DIR
    os.environ["QT_IMPORT_PATH"] = os.path.join(NECESSITAS_QT_DIR, "imports")
    os.environ["QTDIR"] = os.path.join(QT_482_DIR, "armeabi")
    os.environ["LD_LIBRARY_PATH"] = os.path.join(NECESSITAS_QT_DIR, "lib")

    os.environ["QT_PLUGIN_PATH"] = QT_PLUGIN_DIR
    if "QT_PLUGIN_PATH" in os.environ:
        os.environ["QT_PLUGIN_PATH"] += ":%s" % os.environ["QT_PLUGIN_PATH"]

    os.environ["PATH"] = "%s:%s:%s" % (os.path.join(SDK_DIR, "platform-tools"),
                                       os.path.join(os.environ["QTDIR"],
                                                    "bin"),
                                       os.environ["PATH"])


def build():
    """Clean and build the project."""

    os.chdir(PROJECT_DIR)

    print "** creating build directory"
    try:
        os.mkdir(BUILD_DIR)
    except OSError:
        pass

    print "** cleaning previous builds"
    subprocess.call(["make", "clean", "-w"])

    print "** switching to build dir"
    os.chdir(BUILD_DIR)

    print "** running qmake"
    subprocess.call([QMAKE_PATH, PRO_FILE, "-r", "-spec", "android-g++", "-o",
                     "Makefile", PRO_FILE])

    print "** processing makefile"
    subprocess.call(["make", "-w"])

    print "** installing results"
    subprocess.call(["make", "INSTALL_ROOT=%s" % INSTALL_ROOT,
                     "install", "-w"])

    print "** switching to %s" % INSTALL_ROOT
    os.chdir(INSTALL_ROOT)

    print "** building the APK"
    subprocess.call(["ant", "clean", "debug"])


def deploy():
    """Deploy the app to the device."""

    print "** deploying APK"
    subprocess.call([get_adb_path(), "uninstall", get_package_name()])
    subprocess.call([get_adb_path(), "install", APK_PATH])


def complete_deploy(show_log=True):
    """
    Zip the PySide app, clean, build and deploy the project, then start it.
    """
    zip_app.zip_app()
    zip_libs.zip_libs()
    export_environment_variables()
    build()
    deploy()
    restart_app(show_log)


if __name__ == "__main__":
    complete_deploy(show_log=True)
