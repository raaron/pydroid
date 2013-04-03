#!/usr/bin/env bash

# Strips all binaries in the pydroid folder.

# Example usage:
# ./strip_binaries.sh

DEV_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PYDROID_ROOT_DIR=$DEV_DIR/..

ANDROID_EABI_STRIP_PATH=$HOME/necessitas/android-ndk/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin/arm-linux-androideabi-strip

STRIP_CMD="$ANDROID_EABI_STRIP_PATH --strip-unneeded -v -s"

echo "Start stripping all binaries under the following path:"
echo $PYDROID_ROOT_DIR
echo "This may take a while..."

find $PYDROID_ROOT_DIR | xargs file | grep "shared object" | grep ELF | awk -F: '{print $1}' | xargs -d'\n' -r $STRIP_CMD

echo "Done."