#!/usr/bin/python

# Zipps everything in the directory "libs" and places the created archive
# in android/res/raw

import os
import zipfile

from path_utils import project_dir, project_libs_dir, libs_zip_file


def zip_libs():
    """Remove the old zip archive and create the new one from libs."""

    print "Removing old zip archive..."
    print
    try:
        os.remove(libs_zip_file())
    except OSError:
        pass

    print "Creating new zip archive at:"
    print libs_zip_file()

    zf = zipfile.ZipFile(libs_zip_file(), mode='w')
    try:
        root_len = len(project_dir())
        for root, dirs, files in os.walk(project_libs_dir()):
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
