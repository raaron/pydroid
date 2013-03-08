#!/usr/bin/python

# Zipps files in APP_DIR and places the created archive in android/res/raw

import sys
import os
import zipfile

from script_utils import compile_app_directory
from path_utils import project_dir, app_dir, app_zip_file


def zip_app():
    """Remove the old zip archive and create the new one for APP_DIR."""

    if not compile_app_directory():
        sys.exit(0)

    print "Removing old zip archive..."
    print
    try:
        os.remove(app_zip_file())
    except OSError:
        pass

    print "Creating new zip archive at:"
    print app_zip_file()

    zf = zipfile.PyZipFile(app_zip_file(), mode='w')
    print '******', project_dir()
    os.chdir(project_dir())
    try:
        zf.writepy(app_dir(), 'app')
        root_len = len(project_dir())
        for root, dirs, files in os.walk(app_dir()):
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
