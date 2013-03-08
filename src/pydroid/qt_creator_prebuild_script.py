#!/usr/bin/python

# This script gets executed as a pre-build step by QtCreator before
# each deployment.


import os
import sys

import zip_app
import zip_libs


def main():
    """Zip APP_DIR and LIBS_DIR."""
    os.chdir(sys.argv[1])
    zip_app.zip_app()
    zip_libs.zip_libs()


if __name__ == '__main__':
    main()
