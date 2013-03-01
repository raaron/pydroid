pydroid
=======

Framework for PySide on Android based on the work of Martin Kolmann.
This project provides helpers for simple project creation and deployment.

Creating a new project
----------------------
    ./pydroid my_project_name my.domain.name

The created app is already deployable and shows a simple Hello world. The directory my_project_name/app contains the important python and qml files: main.py and view.qml.

Then open the file my_project_name.pro in the Necessitas Qt Creator and deploy the app using the green deploy button.

Deploying the project to the Android device
-------------------------------------------
After editing any file in the "app" directory, zipping this directory into android/res/raw is required before deploying the app to the device. This is automatically done when using Complete Deploy and Fast Deploy by the script scripts/zip_app.py. Additional files in the direcory "app" that also have to be zipped, have to be specified in this script.

### Complete Deployment (slow)
Use this variant for the first deployment or if you made changes in any file outside of the folder 'app', e.g. in 'python_lib' by adding a new python package.
By pressing the "Run" button in QtCreator the 'app' folder is automatically zipped. The complete project is then deployed to the device. This takes much more time than using the Fast Deploy.

### Fast Deployment
Use this variant, if you made changes inside the folder 'app' only. You need a rooted device to be able to perform this deployment variant.
The following script removes the old files in the directory 'app' from the device and inserts the new ones instaed.

    ./fast_deploy

You can add this script to

    QtCreator->Tools->External->Configure->Add->Add Tool

Browse to the executable located at pydroid/framework/project_skeleton/fast_deploy. Set the 'Working directory' to %{CurrentProject:Path}. You may then assign a keyboard shortcut (e.g. ctrl+h) to this tool via Tools->External->Options->Keyboard. Just type the first letters of fast_deploy to quickly find the created external tool.

Rename a project
----------------
    ./rename new_name new.domain


Add python packages
-------------------
If you have pip installed (on Ubuntu: 'sudo easy_install pip'), you can use the following commands to install new packages into python_lib and then zip them again:

    ./pydroid_pip_install package_name
    ./zip_python_lib

Then perform a 'Complete Deployment' to deploy the created library with the additional module.