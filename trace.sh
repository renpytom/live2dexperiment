#!/bin/bash

set -e

export CUBISM=/home/tom/ab/live2d/Cubism3SDKforNative/
export RENPY=/home/tom/ab/renpy/
export LD_LIBRARY_PATH="$CUBISM/Core/dll/linux/x86_64/"
export RENPY_RENDERER=gl2

export RENPY_GDB="apitrace trace -o renpy.trace"

python setup.py install -q
$RENPY/run.sh .
qapitrace renpy.trace
