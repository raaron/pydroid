import sys
import os
import ConfigParser


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


def global_scripts_dir():
    return os.path.join(pydroid_dir(), 'scripts')


########## Project specific paths #############################################


def local_scripts_dir():
    return os.path.dirname(os.path.realpath(__file__))


def project_dir():
    return os.path.dirname(local_scripts_dir())


def build_dir():
    return os.path.join(project_dir(), 'build')


def qtcreator_config_file():
    return os.path.join(project_dir(), '%s.pro' % app_name())


def project_config_file():
    return os.path.join(project_dir(), 'project.conf')


def naming_config_file():
    return os.path.join(project_dir(), '.naming.conf')


def android_dir():
    return os.path.join(project_dir(), 'android')


def android_res_raw_dir():
    return os.path.join(android_dir(), 'res', 'raw')


def app_zip_file():
    return os.path.join(android_res_raw_dir(), 'app.zip')


def libs_zip_file():
    return os.path.join(android_res_raw_dir(), 'libs.zip')


def apk_file():
    return os.path.join(android_dir(), 'bin', "%s-debug.apk" % app_name())


def project_libs_dir():
    return os.path.join(project_dir(), 'libs')


def python27_dir():
    return os.path.join(project_libs_dir(), 'python27')


def site_packages_dir():
    return os.path.join(python27_dir(), 'lib', 'python2.7', 'site-packages')


def app_dir():
    return os.path.join(project_dir(), 'app')


def pydroid_dir():
    p = os.path.dirname(project_dir())
    if p.endswith('framework'):
        return os.path.dirname(p)
    else:
        return p


def libs_config_file():
    return os.path.join(framework_libs_dir(), 'libs.conf')


def app_name():
    return __get_from_config("General", "app_name", naming_config_file())


def package_name():
    return __get_from_config("General", "package_name", naming_config_file())


################ Necessitas / QtCreator specific paths ########################


def adb_path():
    return __get_from_config("Compiling", "adb_path", project_config_file())


def arm_version():
    return __get_from_config("Compiling", "arm_version", project_config_file())


def necessitas_dir():
    return __get_from_config("Compiling", "necessitas_dir",
                             project_config_file())


def necessitas_sdk_dir():
    return os.path.join(necessitas_dir(), "android-sdk")


def necessitas_android_qt_482_dir():
    return os.path.join(necessitas_dir(), "Android", "Qt", "482")


def necessitas_qmake_path():
    return os.path.join(necessitas_android_qt_482_dir(), "armeabi-%s" % arm_version(),
                        "bin", "qmake")


def necessitas_qtcreator_qt_dir():
    return os.path.join(necessitas_dir(), "QtCreator", "Qt")


def necessitas_qtcreator_qt_plugin_dir():
    return os.path.join(necessitas_qtcreator_qt_dir(), "plugins")


################# Android device specific paths ###############################


def device_sdcard_dir():
    return "/sdcard"


def device_app_dir():
    return "/data/data/%s/files/app/" % package_name()


def __get_from_config(section, name, config_file):
    """Return this entry from the config file."""

    conf = ConfigParser.ConfigParser()
    conf.read(config_file)
    return conf.get(section, name)


if __name__ == '__main__':
    import inspect
    for m in inspect.getmembers(sys.modules[__name__], inspect.isfunction):
        if not m[0].startswith('__'):
            print "%-40s--" % m[0], "Exists: %-6s-- " % os.path.exists(m[1]()), m[1]()