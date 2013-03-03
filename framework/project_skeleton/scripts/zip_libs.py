#!/usr/bin/python

# Zipps everything in the directory "libs" and places the created archive
# in android/res/raw

import os
import zipfile

from script_utils import PROJECT_DIR, LIBS_DIR

ZIP_PATH = os.path.join(PROJECT_DIR, "android", "res", "raw", "libs.zip")


def zip_libs():
    """Remove the old zip archive and create the new one from libs."""

    print "Removing old zip archive..."
    print
    try:
        os.remove(ZIP_PATH)
    except OSError:
        pass

    print "Creating new zip archive at:"
    print ZIP_PATH

    zf = zipfile.ZipFile(ZIP_PATH, mode='w')
    try:
        root_len = len(PROJECT_DIR)
        for root, dirs, files in os.walk(LIBS_DIR):
            dir_path_from_root = root[root_len:]
            for f in files:
                fullpath = os.path.join(root, f)
                archive_name = os.path.join(dir_path_from_root, f)
                zf.write(fullpath, archive_name)
    finally:
        zf.close()

    print "Done."


if __name__ == '__main__':
    zip_libs()
