#!/bin/bash

set -e

export CUBISM=${CUBISM:-$PWD/CubismSDKforNative/}
export RENPY=${RENPY:-$PWD/../renpy/}
export PLATFORM=${PLATFORM:-linux/x86_64}

export LD_LIBRARY_PATH="$CUBISM/Core/dll/$PLATFORM"
export RENPY_RENDERER=gl2

python3 generate.py > live2dcsm.pxi
cython -I $RENPY live2dmodel.pyx
python setup.py install -q

exec $RENPY/run.sh .
