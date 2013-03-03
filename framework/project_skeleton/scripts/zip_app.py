#!/usr/bin/python

# Zipps files in APP_DIR and places the created archive in android/res/raw

import sys
import os
import zipfile

from script_utils import PROJECT_DIR, APP_DIR, compile_app_directory


# Python files are automatically included into the generated zip archive.
# Add additional files to include in the zip archive here
NON_PYTHON_FILES = ["view.qml"]

ZIP_PATH = os.path.join(PROJECT_DIR, "android", "res", "raw", "app.zip")


def zip_app():
    """Remove the old zip archive and create the new one for APP_DIR."""

    if not compile_app_directory():
        sys.exit(0)

    print "Removing old zip archive..."
    print
    try:
        os.remove(ZIP_PATH)
    except OSError:
        pass

    print "Creating new zip archive at:"
    print ZIP_PATH

    zf = zipfile.PyZipFile(ZIP_PATH, mode='w')
    os.chdir(PROJECT_DIR)
    try:
        zf.writepy('app', 'app')
        for fn in NON_PYTHON_FILES:
            zf.write(os.path.join(APP_DIR, fn), os.path.join('app', fn))
    finally:
        zf.close()

    print "Done."


if __name__ == '__main__':
    zip_app()
