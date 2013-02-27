import os
from ctypes import *


is_on_android = "EXTERNAL_STORAGE" in os.environ


def load_shiboken_and_pyside():
    """
    PySide bindings can't find the libshiboken.so and libshiboken.
    Load them manually to memory with ctypes before any PySide import.
    """
    # PYSIDE_APPLICATION_FOLDER is set in main.h in the Example project
    PROJECT_FOLDER = os.environ['PYSIDE_APPLICATION_FOLDER']
    LIB_DIR = os.path.join(PROJECT_FOLDER, 'files/python/lib')
    CDLL(os.path.join(LIB_DIR, 'libshiboken.so'))
    CDLL(os.path.join(LIB_DIR, 'libpyside.so'))
