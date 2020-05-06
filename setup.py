from distutils.core import setup
from distutils.extension import Extension
import os

RENPY = os.environ["RENPY"]
CUBISM = os.environ["CUBISM"]
PLATFORM = os.environ["PLATFORM"]

extensions = [
    Extension(
        "live2dmodel", ["live2dmodel.c"],
        include_dirs=[ CUBISM + "/Core/include/", "/usr/include/SDL2" ],
        libraries=[ "SDL2" ],
        ),
]

setup(
    name="live2d",
    ext_modules=extensions,
)
