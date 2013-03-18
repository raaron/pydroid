#!/bin/bash

STRIP="/home/aaron/necessitas/android-ndk/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86/bin//arm-linux-androideabi-strip --strip-unneeded -v -s"

find . | xargs file | grep "shared object" | grep ELF | awk -F: '{print $1}' | xargs -d'\n' -r $STRIP