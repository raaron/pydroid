#!/usr/bin/python

# Zipps everything in the directory "python_lib" and places the created archive
# in android/res/raw

import os
import zipfile

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))

ZIP_PATH = os.path.join(PROJECT_DIR, "android", "res", "raw", "python_27.zip")
LIB_DIR = os.path.join(PROJECT_DIR, 'python_lib')


def zip_lib():
    """Remove the old zip archive and create the new one from python_lib."""

    print "Removing old zip archive..."
    print
    try:
        os.remove(ZIP_PATH)
    except OSError:
        pass

    print "Creating new zip archive at:"
    print ZIP_PATH

    zf = zipfile.ZipFile(ZIP_PATH, mode='w')
    os.chdir(LIB_DIR)
    try:
        root_len = len(os.path.abspath(LIB_DIR))
        for root, dirs, files in os.walk(LIB_DIR):
            archive_root = os.path.abspath(root)[root_len:]
            for f in files:
                fullpath = os.path.join(root, f)
                archive_name = os.path.join(archive_root, f)
                zf.write(fullpath, archive_name)
    finally:
        zf.close()

    print "Done."


if __name__ == '__main__':
    zip_lib()
