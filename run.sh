#!/bin/bash

set -e

export CUBISM=${CUBISM:-$PWD/CubismSDKforNative/}
export RENPY=${RENPY:-$PWD/../renpy/}
export PLATFORM=${PLATFORM:-linux/x86_64}

export LD_LIBRARY_PATH="$CUBISM/Core/dll/$PLATFORM"

exec $RENPY/run.sh .
