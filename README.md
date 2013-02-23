pydroid
=======

Framework for PySide on Android based on the work of Martin Kollmann.
This project provides helpers for simple project creation, deployment and renaming.

Creating a new project
----------------------
./pydroid my_project_name my.domain.name

The created app is already deployable and shows a simple Hello world. The directory my_project_name/app contains the important python and qml files: main.py and view.qml.

Deploying the project to the Android device
-------------------------------------------
After editing any file in the "app" directory, zipping this directory into android/res/raw is required before deploying the app to the device:

./zip_project

Open the file my_project_name.pro in the Necessitas Qt Creator and deploy the app using the green deploy button.