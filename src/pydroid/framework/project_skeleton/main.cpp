#include <Python.h>
#include "main.h"
#include <dlfcn.h>
#include <iostream>
#include <fstream>
#include <string.h>
#include <sys/stat.h>

using namespace std;

/**
    Try to load a .so file. Exits the application in case of an error.

    @param path: the absolute path to the library to load.
    @param logfile: write log output to this file.
*/
void open_library(const char *path, ofstream& logfile)
{
    const char *error;

    // The following error is sometimes reported even if everything works fine
    // => Ignore it.
    const char *standard_error = "Symbol not found: ";

    logfile << "Start loading " << path << " ... ";
    logfile.flush();

    // Try to load the library
    dlopen(path, RTLD_NOW);

    // Check if an error occured, if so, terminate the application
    error = dlerror();
    if (error && strcmp(error, standard_error) != 0)
    {
        logfile << "Error:\n" << error;
        logfile.close();
        exit(1);
    } else {
        logfile << "Done.\n";
    }
}


int main(int argc, char *argv[])
{
    ofstream logfile;

    // Setup paths and directory for logging
    char logpath[80] = LOG_DIR;
    strcat(logpath, "cpp_log.txt");
    mkdir(LOG_DIR, 777);
    logfile.open(logpath);
    logfile << "Entered main() method of main.cpp.\n\n";
    logfile << "Start setting environment variables... ";
    logfile.flush();

    // Set environment variables (defined in main.h)
    setenv("PYTHONHOME", PYTHON_HOME, 1);
    setenv("PYTHONPATH", PYTHON_PATH, 1);
    setenv("LD_LIBRARY_PATH", LD_LIBRARY_PATH, 1);
    setenv("PATH", PATH, 1);
    setenv("M_THEME_DIR", THEME_PATH, 1);
    setenv("QML_IMPORT_PATH", QML_IMPORT_PATH, 1);
    setenv("LOG_DIR", LOG_DIR, 1);
    logfile << "Done.\n";

    // Try to load libshiboken.so and libpyside.so
    open_library(LIBSHIBOKEN_PATH, logfile);
    open_library(LIBPYSIDE_PATH, logfile);

    logfile << "\nStarting python application...\n";
    logfile.close();

    // Start the python application
    Py_Initialize();
    PySys_SetArgv(argc, argv);
    PySys_SetPath((char *)PYTHON_PATH);
    FILE *fp = fopen(MAIN_PYTHON_FILE, "r");
    PyRun_SimpleFile(fp, MAIN_PYTHON_FILE);
    fclose(fp);
    Py_Finalize();
}
