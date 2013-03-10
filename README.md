pydroid
=======

Framework for PySide on Android based on the work of Martin Kolmann.
This project provides helpers for simple project creation and deployment.


Set up your system
------------------

Install pydroid with the following command:

    sudo python setup.py install

Before deploying your first app, you have to adapt the following config file according to your system:

    ~/.pydroid/deploy.conf

You can always check your system or your project with the following command:

    pydroid check


Creating a new project
----------------------
    pydroid create name:app my_project_name domain:my.domain

The created app is already deployable and shows a simple Hello world. The directory my_project_name/app contains the important python and qml files: controller.py, view.py, model.py and view.qml.

For deploying the created app to the device, see the 'Deploying' section.

Creating an example project
---------------------------
There are many runnable examples (you can list the available examples using the autocompletion by hitting 'TAB' after 'pydroid create example'):

    pydroid create example hello_world


Deploying the project to the Android device
-------------------------------------------

### Complete Deployment (slow)
Use this variant for the first deployment or if you made changes in any file outside of the folder 'app', e.g. in 'libs' by adding a new python package. There are two options to perform a complete deployment:

Commandline:

    pydroid deploy complete

QtCreator:

By pressing the "Run" button in QtCreator the entire project is deployed to the device. This takes much more time than using the "Fast Deployment".


### Fast Deployment
Use this variant, if you made changes inside the folder 'app' only. You need a rooted device to be able to perform this deployment variant.
The script removes the old files in the directory 'app' from the device and inserts the new ones instaed. There are two options to perform a fast deployment:

Commandline:

    pydroid deploy fast


QtCreator:

You can add this script to

    QtCreator->Tools->External->Configure->Add->Add Tool

Browse to the executable located at /usr/local/lib/python2.7/dist-packages/pydroid-0.1.1-py2.7.egg/pydroid/fast_deploy.py. Set the 'Working directory' to %{CurrentProject:Path}. You may then assign a keyboard shortcut (e.g. ctrl+h) to this tool via Tools->External->Options->Keyboard. Just type the first letters of "fast_deploy.py" to quickly find the created external tool.


Rename a project
----------------
    pydroid rename name:new_name domain:new.domain
Be sure, to use the "Complete Deployment" method for the next deployment!


Add additional libraries
------------------------

###Python packages (available via pip)
If you have pip installed (on Ubuntu: 'sudo easy_install pip'), you can use the following commands to install new packages into 'libs/python27':

    pydroid pip install package_name

Be sure, to use the "Complete Deployment" method for the next deployment!

###Other libraries
The following command adds an additional library to your project (you can list the available libraries using the autocompletion by hitting 'TAB' after 'pydroid add library'):

    pydroid add library library_name


Get information and status of your project
------------------------------------------
The following command provides you with information about the most important
paths of your project, the (estimated) size of the APK and the decompressed app
and about some general settings for debugging:

    pydroid status

Logging
-------
You can log the string representation of any python object to the normal android logcat (displayed by QtCreator when running the app) with the following command:

    from android_util import log
    log(any_object)

Or if you prefer having visual log output on your device, you may use the following:

    from android_util import logv
    logv(any_object)

This shows the string representation of any python object in a MessageBox on the device.
