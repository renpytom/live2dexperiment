#!/bin/bash

set -e

export CUBISM=/home/tom/ab/live2d/Cubism3SDKforNative/
export RENPY=/home/tom/ab/renpy/
export PLATFORM=linux/x86_64

export LD_LIBRARY_PATH="$CUBISM/Core/dll/linux/x86_64/"

export RENPY_RENDERER=gl2


cython -I $RENPY live2dmodel.pyx
python setup.py install -q
exec $RENPY/run.sh .
