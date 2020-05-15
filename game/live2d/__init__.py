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

        renpy.display.log.write("Loading Live2D from %r.", filename)

        if not renpy.exports.loadable(filename):
            raise Exception("Live2D model {} does not exist.".format(filename))

        # A short name for the model.
        model_name = filename.rpartition("/")[2].partition(".")[0].lower()

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

        def walk_json_files(o, l):
            if isinstance(o, list):
                for i in o:
                    walk_json_files(i, l)
                return

            if "File" in o:
                l.append(o["File"])
                return

            for i in o.values():
                walk_json_files(i, l)

        motion_files = [ ]
        walk_json_files(self.model_json["FileReferences"].get("Motions", { }), motion_files)

        # A list of attributes that are known.
        self.attributes = set()

        # A map from a motion name to a motion identifier.
        self.motions = { }

        for i in motion_files:
            name = i.lower().rpartition("/")[2].partition(".")[0]

            prefix, _, suffix = name.partition("_")

            if prefix == model_name:
                name = suffix

            renpy.display.log.write(" - motion %s -> %s", name, i)

            self.motions[name] = live2d.motion.Motion(self.base + i)
            self.attributes.add(name)


# This maps a filename to a Live2DCommon object.
common_cache = { }


class Live2D(renpy.exports.Displayable):

    nosave = [ "common_cache" ]

    common_cache = None
    _duplicatable = True

    @property
    def common(self):
        if self.common_cache is not None:
            return self.common_cache

        rv = common_cache.get(self.filename, None)

        if rv is None:
            rv = Live2DCommon(self.filename)
            common_cache[self.filename] = rv

        self.common_cache = rv
        return rv

    def __init__(self, filename, motion=None, zoom=None, top=0.0, base=1.0, **properties):

        if base is not None:
            properties.setdefault("yanchor", base)

        super(Live2D, self).__init__(**properties)

        self.filename = filename
        self.motion = motion

        self.zoom = zoom
        self.top = top
        self.base = base

        # Load the common data.
        _ = self.common

    def _duplicate(self, args):

        common = self.common
        motion = self.motion

        for i in args.args:
            if i in common.motions:
                if motion is not None:
                    raise Exception("When showing {}, {} and {} are both motions.".format(args.name, motion, i))
                else:
                    motion = i

                continue

            raise Exception("When showing {}, {} is not a known attribute.".format(args.name, i))

        rv = Live2D(self.filename, motion=motion, zoom=self.zoom, top=self.top, base=self.base)
        rv._duplicatable = False
        return rv

    def _list_attributes(self, tag, attributes):

        common = self.common

        available = set(common.attributes)

        for i in attributes:

            if i in common.motions:
                available -= set(common.motions)

        available |= set(attributes)

        return [ i for i in common.attributes if i in available ]

    def _choose_attributes(self, tag, attributes, optional):

        motion = None

        common = self.common

        for i in optional:
            if i in common.motions:
                motion = i

        for i in attributes:
            if i in common.motions:
                motion = i

        return (motion,)

    def render(self, width, height, st, at):

        if self.motion is not None:
            renpy.exports.redraw(self, 0)

        common = self.common
        model = common.model

        textures = [ renpy.exports.render(d, width, height, st, at) for d in common.textures ]

        motion = common.motions.get(self.motion, None)

        if motion is not None:

            for k, v in motion.get(st).items():

                kind, key = k

                if kind == "Parameter":
                    common.model.set_parameter(key, v)
                else:
                    common.model.set_part_opacity(key, v)

        rend = model.render(textures)
        sw, sh = rend.get_size()

        zoom = self.zoom

        def s(n):
            if isinstance(n, float):
                return n * sh
            else:
                return n

        if zoom is None:
            top = s(self.top)
            base = s(self.base)

            size = max(base - top, 1.0)

            zoom = 1.0 * height / size

        rv = renpy.exports.Render(sw * zoom, sh * zoom)
        rv.blit(rend, (0, 0))

        if zoom != 1.0:
            rv.reverse = renpy.display.matrix.Matrix.scale(zoom, zoom, 1.0)
            rv.forward = renpy.display.matrix.Matrix.scale(1 / zoom, 1 / zoom, 1.0)

        return rv

    def visit(self):
        return self.common.textures

