import os
from setuptools import setup


def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()


def get_package_data():
    result = []
    framework_dir = os.path.abspath(os.path.join('src', 'pydroid', 'framework'))
    root_len = len(os.path.dirname(framework_dir))
    for root, dirs, files in os.walk(framework_dir):
        dir_path_from_root = root[root_len + 1:]
        for f in files:
            result.append(os.path.join(dir_path_from_root, f))

    # # Include config files:
    # result.append('deploy.conf')
    return result


home = os.path.expanduser('~')
user_pydroid_config_dir = os.path.join(home, '.pydroid')


setup(name='pydroid',
      version='0.1.1',
      author="Aaron Richiger, Martin Kolman",
      author_email="a.richi@bluewin.ch",
      description="PySide for Android. A framework for creating and" \
                  "deploying PySide (Qt bindings for python) applications" \
                  "to Android devices.",

      data_files=[('/etc/bash_completion.d', ['pydroid.completion']),
                  (user_pydroid_config_dir,
                            [os.path.join('src', 'pydroid', 'deploy.conf')])],

      license="LGPL",
      keywords="pyside android framework",
      url="http://packages.python.org/an_example_pypi_project",
      long_description=read('README.md'),
      packages=['pydroid'],
      package_dir={'pydroid': 'src/pydroid'},
      package_data={'pydroid': get_package_data()},
      scripts=[os.path.join('bin', 'pydroid')]
      )

os.chmod(os.path.join(user_pydroid_config_dir, 'deploy.conf'), 0666)
