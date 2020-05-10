# Copyright 2004-2020 Tom Rothamel <pytom@bishoujo.us>
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

from __future__ import division, absolute_import, with_statement, print_function, unicode_literals
from renpy.compat import *
import renpy.exports

import live2dmodel
import live2d.motion
import json
import os

live2dmodel.load(os.environ["CUBISM"] + "/Core/dll/linux/x86_64/libLive2DCubismCore.so")


class Live2DCommon(object):
    """
    This object stores information that is common to all of the Live2D
    displayables that use the same .model3.json file, so this information
    only needs to be loaded once. This should not leak into the save games,
    but is loaded at init time.
    """

    def __init__(self, filename):

        # If a directory is given rather than a json file, expand it.
        if not filename.endswith(".json"):
            suffix = filename.rpartition("/")[2]
            filename = filename + "/" + suffix + ".model3.json"

        if not renpy.exports.loadable(filename):
            raise Exception("Live2D model {} does not exist.".format(filename))

        # The path to where the files used are stored.
        self.base = filename.rpartition("/")[0]

        if self.base:
            self.base += "/"

        # The contents of the .model3.json file.
        self.model_json = json.load(renpy.exports.file(filename))

        # The model created from the moc3 file.
        self.model = live2dmodel.Live2DModel(self.base + self.model_json["FileReferences"]["Moc"])

        # The texture images.
        self.textures = [ ]

        for i in self.model_json["FileReferences"]["Textures"]:
            self.textures.append(renpy.exports.displayable(self.base + i))

        # The motion information.
        self.motions = { }

        motion_files = [ ]

        def walk_motions(o):
            if isinstance(o, list):
                for i in o:
                    walk_motions(i)
                return

            if "File" in o:
                motion_files.append(o["File"])
                return

            for i in o.values():
                walk_motions(i)

        walk_motions(self.model_json["FileReferences"].get("Motions", { }))

        print(motion_files)

        # self.motion = live2d.motion.Motion(self.base + "motions/" + motion + ".motion3.json")


Live2DCommon("Resources/Hiyori")

# class Live2D(object):
#
#     def __init__(self, filename, motion, **properties):
#         super(Live2D, self).__init__(**properties)
#
#         # The path to where the files used are stored.
#         self.base = filename.rpartition("/")[0]
#
#         if self.base:
#             self.base += "/"
#
#         # The contents of the .model3.json file.
#         self.model_json = json.load(renpy.file(filename))
#
#         # The model created from the moc3 file.
#         self.model = live2dmodel.Live2DModel(self.base + self.model_json["FileReferences"]["Moc"])
#
#         # The texture images.
#         self.textures = [ ]
#
#         for i in self.model_json["FileReferences"]["Textures"]:
#             self.textures.append(renpy.displayable(self.base + i))
#
#         # The motion information.
#         self.motion = live2d.motion.Motion(self.base + "motions/" + motion + ".motion3.json")
#
#     def render(self, width, height, st, at):
#
#         renpy.redraw(self, 0)
#         textures = [ renpy.render(d, width, height, st, at) for d in self.textures ]
#
#         for k, v in self.motion.get(st).items():
#
#             kind, key = k
#
#             if kind == "Parameter":
#                 self.model.set_parameter(key, v)
#             else:
#                 self.model.set_part_opacity(key, v)
#
#         return self.model.render(textures)
