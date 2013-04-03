#!/usr/bin/env bash

# Helper script to speed up the process between changing the pyjnius code and
# having an app using the changed pyjnius lib by doing the following:
#   - Recompiles python and pyjnius
#   - Injects the generated libraries into pydroid
#   - Removes previous pyjnius_example if any from test_dir
#   - Creates a new pyjnius_example app
#   - Deploys the app to the device
#   - Creates a backup of the deploy.conf file for later restore.

# Example usage:
# ./compile_pyjnius_and_create_app.sh


######################## PATHS TO ADAPT #######################################

# Path to the python-for-android directory, ensure being on "minimal" branch
# Download and activate the "minimal" branch with the following command:
#   git checkout -b minimal remotes/origin/minimal
PYTHON_FOR_ANDROID_DIR=$HOME/python-for-android

# Paths to android sdk and ndk
export ANDROIDSDK="$HOME/android-sdk-linux"
export ANDROIDNDK="$HOME/android-ndk-r8c"

######################## NO MORE ADAPTIONS REQUIRED ###########################


export ANDROIDNDKVER=r8c
export ANDROIDAPI=14

DEV_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEST_DIR=$HOME/pydroid_test
APP_DIR=$TEST_DIR/pyjnius_example
ACTIVITY_FILE=$APP_DIR/android/src/org/kde/necessitas/origo/QtActivity.java


# (Re-)compile pyjnius and python libs, inject them into pydroid
rm -rf $PYTHON_FOR_ANDROID_DIR/dist/default
$PYTHON_FOR_ANDROID_DIR/distribute.sh -m "pyjnius minimal"
$DEV_DIR/copy_kivy_libs.sh

# Remove unnecessary stuff in the library
$DEV_DIR/cleanup_python_lib.sh

# Remove previous app, create a new one
rm -rf $APP_DIR
cd $TEST_DIR
pydroid create example pyjnius

# Deploy it
cd $APP_DIR
pydroid deploy complete