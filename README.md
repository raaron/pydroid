pydroid
=======

Framework for PySide on Android based on the work of Martin Kolmann.
This project provides helpers for simple project creation and deployment.


Set up your system
------------------
Before starting using the framework, you have to adapt the following config file according to your system:

    framework/project_skeleton/project.conf


Creating a new project
----------------------
    ./pydroid my_project_name my.domain.name

The created app is already deployable and shows a simple Hello world. The directory my_project_name/app contains the important python and qml files: main.py and view.qml.

Then open the file my_project_name.pro in the Necessitas Qt Creator and deploy the app using the green deploy button.

Additionally, there is a script for creating, deploying and running a "Hello world!" app with one single command (requires your system to be set up correctly, see "Set up your system" above):

    ./hello


Deploying the project to the Android device
-------------------------------------------
After editing any file in the "app" directory, zipping this directory into android/res/raw is required before deploying the app to the device. This is automatically done when using Complete Deploy and Fast Deploy by the script scripts/zip_app.py. Additional files in the direcory "app" that also have to be zipped, have to be specified in this script.


### Complete Deployment (slow)
Use this variant for the first deployment or if you made changes in any file outside of the folder 'app', e.g. in 'libs' by adding a new python package. There are two options to perform a complete deployment:

QtCreator:
By pressing the "Run" button in QtCreator the 'app' folder is automatically zipped. The complete project is then deployed to the device. This takes much more time than using the Fast Deploy.

Commandline:

    ./complete_deploy


### Fast Deployment
Use this variant, if you made changes inside the folder 'app' only. You need a rooted device to be able to perform this deployment variant.
The script removes the old files in the directory 'app' from the device and inserts the new ones instaed. There are two options to perform a fast deployment:

Commandline:
    ./fast_deploy

QtCreator:
You can add this script to

    QtCreator->Tools->External->Configure->Add->Add Tool

Browse to the executable located at pydroid/framework/project_skeleton/fast_deploy. Set the 'Working directory' to %{CurrentProject:Path}. You may then assign a keyboard shortcut (e.g. ctrl+h) to this tool via Tools->External->Options->Keyboard. Just type the first letters of fast_deploy to quickly find the created external tool.


Rename a project
----------------
    ./rename new_name new.domain
Be sure, to use the "Complete Deployment" method for the next deployment!


Add python packages
-------------------
If you have pip installed (on Ubuntu: 'sudo easy_install pip'), you can use the following commands to install new packages into 'libs/python27' (zipping the new libs is done automatically with this command):

    ./pydroid_pip_install package_name

Be sure, to use the "Complete Deployment" method for the next deployment!

Logging
-------
You can log the string representation of any python object to the normal android logcat (displayed by QtCreator when running the app) with the following command:

    from android_util import log
    log(any_object)

Or if you prefer having visual log output on your device, you may use the following:

    from android_util import logv
    logv(any_object)

This shows the string representation of any python object in a MessageBox on the device.
