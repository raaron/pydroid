#!/usr/bin/python

# Installs a python package into 'libs/python27' using 'pip'

import sys
import os
from pip.index import PackageFinder
from pip.req import InstallRequirement, RequirementSet
from pip.locations import build_prefix, src_prefix
from pip.exceptions import DistributionNotFound


PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
LIB_DIR = os.path.join(PROJECT_DIR, 'libs', 'python27')


def install(name):
    """Try to install the package with 'name' into folder 'libs/python27'."""

    print "Installation directory:"
    print LIB_DIR

    requirement_set = RequirementSet(build_dir=build_prefix,
                                     src_dir=src_prefix,
                                     download_dir=None)

    requirement_set.add_requirement(InstallRequirement.from_line(name, None))

    install_options = ["--prefix=%s" % LIB_DIR]
    global_options = []
    finder = PackageFinder(find_links=[],
                           index_urls=["http://pypi.python.org/simple/"])

    try:
        requirement_set.prepare_files(finder,
                                      force_root_egg_info=False,
                                      bundle=False)

        requirement_set.install(install_options, global_options)

        print "\nSuccessfully installed\n=================================="
        for package in requirement_set.successfully_installed:
            print package.name
        print "\nDone."

    except DistributionNotFound:
        print "No package found with name: %s" % name

    except Exception as e:
        print "Error:", e


def main(argv):
    """
    Start installing the directory, if the syntax was correct.
    """

    if len(argv) != 1:
        print "Error: Invalid argument count: got %d instead of 1." % len(argv)
        print "Syntax: ./pydroid_pip_install package_name"
        sys.exit(1)
    else:
        install(argv[0])

if __name__ == "__main__":
    main(sys.argv[1:])
    # install('simplekv')
