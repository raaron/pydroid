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

from path_utils import *
from script_utils import restart_app


def export_environment_variables():
    """Export all necessary variables for the build."""

    os.environ["ANDROID_NDK_HOST"] = "linux-x86"
    os.environ["ANDROID_NDK_PLATFORM"] = "android-14"
    os.environ["ANDROID_NDK_ROOT"] = os.path.join(necessitas_dir(),
                                                  "android-ndk")

    os.environ["ANDROID_NDK_TOOLCHAIN_PREFIX"] = "arm-linux-androideabi"
    os.environ["ANDROID_NDK_TOOLCHAIN_VERSION"] = "4.4.3"
    os.environ["ANDROID_NDK_TOOLS_PREFI"] = "arm-linux-androideabi"
    os.environ["ANDROID_HOME"] = necessitas_sdk_dir()
    os.environ["QT_IMPORT_PATH"] = os.path.join(necessitas_qtcreator_qt_dir(),
                                                "imports")

    os.environ["QTDIR"] = os.path.join(necessitas_android_qt_482_dir(),
                                       "armeabi")

    os.environ["LD_LIBRARY_PATH"] = os.path.join(necessitas_qtcreator_qt_dir(),
                                                 "lib")

    os.environ["QT_PLUGIN_PATH"] = necessitas_qtcreator_qt_plugin_dir()
    if "QT_PLUGIN_PATH" in os.environ:
        os.environ["QT_PLUGIN_PATH"] += ":%s" % os.environ["QT_PLUGIN_PATH"]

    os.environ["PATH"] = "%s:%s:%s" % (os.path.join(necessitas_sdk_dir(),
                                                    "platform-tools"),
                                       os.path.join(os.environ["QTDIR"],
                                                    "bin"),
                                       os.environ["PATH"])


def build():
    """Clean and build the project."""

    os.chdir(project_dir())

    print "** creating build directory"
    try:
        os.mkdir(build_dir())
    except OSError:
        pass

    print "** cleaning previous builds"
    subprocess.call(["make", "clean", "-w"])

    print "** switching to build dir"
    os.chdir(build_dir())

    print "** running qmake"
    subprocess.call([necessitas_qmake_path(), qtcreator_config_file(), "-r",
                     "-spec", "android-g++", "-o",
                     "Makefile", qtcreator_config_file()])

    print "** processing makefile"
    subprocess.call(["make", "-w"])

    print "** installing results"
    subprocess.call(["make", "INSTALL_ROOT=%s" % android_dir(),
                     "install", "-w"])

    print "** switching to %s" % android_dir()
    os.chdir(android_dir())

    print "** building the APK"
    subprocess.call(["ant", "clean", "debug"])


def deploy():
    """Deploy the app to the device."""

    print "** deploying APK"
    subprocess.call([adb_path(), "uninstall", package_name()])
    subprocess.call([adb_path(), "install", apk_file()])


def complete_deploy(show_log=False):
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
    complete_deploy(show_log=False)
