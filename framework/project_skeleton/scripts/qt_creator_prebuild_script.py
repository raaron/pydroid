#!/usr/bin/python

# This script gets executed as a pre-build step by QtCreator before
# each deployment.


import zip_app
import zip_libs


def main():
    """Zip APP_DIR and LIBS_DIR."""
    zip_app.zip_app()
    zip_libs.zip_libs()


if __name__ == '__main__':
    main()
