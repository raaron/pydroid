#!/usr/bin/python

# Zipps files in the directory "app" and places the created archive in
# android/res/raw

import os
import zipfile


# Python files are automatically included into the generated zipp archive.
# Add additional files to include in the zip archive here
NON_PYTHON_FILES = ["view.qml"]

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))

ZIP_PATH = os.path.join(PROJECT_DIR, "android", "res", "raw", "app.zip")
APP_DIR = os.path.join(PROJECT_DIR, 'app')

print "Removing old zip archive..."
print
try:
    os.remove(ZIP_PATH)
except OSError:
    pass

print "Creating new zip archive at:"
print ZIP_PATH

zf = zipfile.PyZipFile(ZIP_PATH, mode='w')
os.chdir(APP_DIR)
try:
    zf.writepy('.')
    for fn in NON_PYTHON_FILES:
        zf.write(fn)
finally:
    zf.close()

print "Done."
