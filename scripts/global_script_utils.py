import os


def get_local_skeleton_scripts_dir():
    """
    Return the absolute path to the 'scripts' directory in the
    framework/project_skeleton directory.
    """
    pydroid_dir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    return os.path.join(pydroid_dir, 'framework', 'project_skeleton',
                        'scripts')
