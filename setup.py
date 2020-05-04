from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import os

RENPY = os.environ["RENPY"]
CUBISM = os.environ["CUBISM"]
PLATFORM = os.environ["PLATFORM"]

extensions = [
    Extension(
        "live2dmodel", ["live2dmodel.c"],
        include_dirs=[ CUBISM + "/Core/include/" ],
        libraries=[ "Live2DCubismCore" ],
        library_dirs=[ CUBISM + "/Core/dll/linux/x86_64/" ],
        ),
]

setup(
    name="live2d",
    ext_modules=extensions,
)
