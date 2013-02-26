#!/usr/bin/python

# Zipps files in the directory "app" and places the created archive in
# android/res/raw

import os
import zipfile

# Add additional files to include in the zip archive here
ZIPPED_PYTHON_FILES = ["main.py"]
OTHER_ZIPPED_FILES = ["view.qml"]

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
print
print "Included files: %s" % ', '.join(ZIPPED_PYTHON_FILES + OTHER_ZIPPED_FILES)
print

zf = zipfile.PyZipFile(ZIP_PATH, mode='w')
os.chdir(APP_DIR)
try:
    for fn in ZIPPED_PYTHON_FILES:
        zf.writepy('.')
    for fn in OTHER_ZIPPED_FILES:
        zf.write(fn)
finally:
    zf.close()

print "Done."
