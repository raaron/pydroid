pydroid
=======

Framework for PySide on Android based on the work of Martin Kolmann.
This project provides helpers for simple project creation, deployment and renaming.

Creating a new project
----------------------
    ./pydroid my_project_name my.domain.name

The created app is already deployable and shows a simple Hello world. The directory my_project_name/app contains the important python and qml files: main.py and view.qml.

Then open the file my_project_name.pro in the Necessitas Qt Creator and deploy the app using the green deploy button.

Rename a project
----------------
    ./rename new_name new.domain

Deploying the project to the Android device
-------------------------------------------
After editing any file in the "app" directory, zipping this directory into android/res/raw is required before deploying the app to the device. This is automatically done by the script scripts/zip_app.py if the app is deployed using QtCreator. Additional files in the direcory "app" that also have to be zipped, have to be specified in this script.