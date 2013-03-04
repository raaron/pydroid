#!/usr/bin/python

# Zipps files in APP_DIR and places the created archive in android/res/raw

import sys
import os
import zipfile

from script_utils import PROJECT_DIR, APP_DIR, compile_app_directory

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
        zf.writepy(APP_DIR, 'app')
        root_len = len(PROJECT_DIR)
        for root, dirs, files in os.walk(APP_DIR):
            dir_path_from_root = root[root_len:]
            for f in files:
                if not (f.endswith('.py') or f.endswith('.pyc')):
                    fullpath = os.path.join(root, f)
                    archive_name = os.path.join(dir_path_from_root, f)
                    zf.write(fullpath, archive_name)
    finally:
        zf.close()

    print "Done."


if __name__ == '__main__':
    zip_app()
