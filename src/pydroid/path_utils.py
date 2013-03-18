import sys
import os
import ConfigParser


PYDROID_DIR = os.path.dirname(os.path.realpath(__file__))


def ensure_project_dir():
    """
    Ensure the current directory is a project directory,
    otherwise print an error message and terminate the program execution.
    """
    if not is_project_dir():
        print "\nThis functionality is available from the root directory of a pydroid project only.\n"
        sys.exit(0)


def is_project_dir():
    """Is the current directory a pydroid project directory?"""

    cwd_has = os.listdir(os.getcwd())
    should_have = ['libs', 'android', '.naming.conf', 'main.cpp', 'main.h']

    for item in should_have:
        if not item in cwd_has:
            return False

    return True


########### Global pydroid paths ##############################################

def framework_dir():
    return os.path.join(pydroid_dir(), 'framework')


def skeleton_dir():
    return os.path.join(framework_dir(), 'project_skeleton')


def examples_dir():
    return os.path.join(framework_dir(), 'examples')


def examples_config_file():
    return os.path.join(examples_dir(), 'examples.conf')


def framework_libs_dir():
    return os.path.join(framework_dir(), 'libs')


def build_config_file():
    return os.path.join(os.environ['HOME'], '.pydroid', 'deploy.conf')


########## Project specific paths #############################################


def project_dir():
    if is_project_dir():
        return os.getcwd()
    else:
        return ""


def build_dir():
    return os.path.join(project_dir(), 'build')


def qtcreator_config_file():
    return os.path.join(project_dir(), '%s.pro' % app_name())


def naming_config_file():
    return os.path.join(project_dir(), '.naming.conf')


def android_dir():
    return os.path.join(project_dir(), 'android')


def android_bin_dir():
    return os.path.join(android_dir(), 'bin')


def android_gen_dir():
    return os.path.join(android_dir(), 'gen')


def android_res_raw_dir():
    return os.path.join(android_dir(), 'res', 'raw')


def app_zip_file():
    return os.path.join(android_res_raw_dir(), 'app.zip')


def libs_zip_file():
    return os.path.join(android_res_raw_dir(), 'libs.zip')


def apk_file():
    return os.path.join(android_bin_dir(), "%s-debug.apk" % app_name())


def project_libs_dir():
    return os.path.join(project_dir(), 'libs')


def python27_dir():
    return os.path.join(project_libs_dir(), 'python27')


def site_packages_dir():
    return os.path.join(python27_dir(), 'lib', 'python2.7', 'site-packages')


def app_dir():
    return os.path.join(project_dir(), 'app')


def main_python_file():
    return os.path.join(app_dir(), 'main.py')


def pydroid_dir():
    return PYDROID_DIR


def libs_config_file():
    return os.path.join(framework_libs_dir(), 'libs.conf')


def app_name():
    return __get_from_config("General", "app_name", naming_config_file())


def package_name():
    return __get_from_config("General", "package_name", naming_config_file())


################ Necessitas / QtCreator specific paths ########################


def adb_path():
    return __get_from_config("Compiling", "adb_path", build_config_file())


def arm_version():
    return __get_from_config("Compiling", "arm_version", build_config_file())


def necessitas_dir():
    return __get_from_config("Compiling", "necessitas_dir",
                             build_config_file())


def necessitas_sdk_dir():
    return os.path.join(necessitas_dir(), "android-sdk")


def necessitas_android_qt_482_dir():
    return os.path.join(necessitas_dir(), "Android", "Qt", "482")


def necessitas_qmake_path():
    dirname = "armeabi"
    if arm_version() == "v7a":
        dirname += "-%s" % arm_version()

    return os.path.join(necessitas_android_qt_482_dir(), dirname, "bin",
                        "qmake")


def necessitas_qtcreator_qt_dir():
    return os.path.join(necessitas_dir(), "QtCreator", "Qt")


def necessitas_qtcreator_qt_plugin_dir():
    return os.path.join(necessitas_qtcreator_qt_dir(), "plugins")


################# Android device specific paths ###############################


def device_sdcard_dir():
    return "/sdcard/pydroid"


def device_app_dir():
    return "/data/data/%s/files/app/" % package_name()


def device_libs_dir():
    return "/data/data/%s/files/libs/" % package_name()


def __get_from_config(section, name, config_file):
    """Return this entry from the config file."""

    conf = ConfigParser.ConfigParser()
    conf.read(config_file)
    return conf.get(section, name)


if __name__ == '__main__':
    import inspect
    for m in inspect.getmembers(sys.modules[__name__], inspect.isfunction):
        if not (m[0].startswith('__') or m[1] == is_project_dir):
            print "%-40s--" % m[0], "Exists: %-6s-- " % os.path.exists(m[1]()), m[1]()