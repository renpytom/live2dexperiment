define _confirm_quit = False
define config.gl2 = True
define config.transparent_tile = None

define e = Character("Eileen", image="eileen")
define l = Character("Lucy", image="lucy")

init python:

    import live2dmodel
    import live2dmotion
    import math
    import json

    class Live2D(renpy.Displayable):

        def __init__(self, filename, motion, **properties):
            super(Live2D, self).__init__(**properties)

            # The path to where the files used are stored.
            self.base = filename.rpartition("/")[0]

            if self.base:
                self.base += "/"

            # The contents of the .model3.json file.
            self.model_json = json.load(renpy.file(filename))

            # The model created from the moc3 file.
            self.model = live2dmodel.Live2DModel(self.base + self.model_json["FileReferences"]["Moc"])

            # The texture images.
            self.textures = [ ]

            for i in self.model_json["FileReferences"]["Textures"]:
                self.textures.append(renpy.displayable(self.base + i))

            # The motion information.
            self.motion = live2dmotion.Live2DMotion(self.base + "motions/" + motion + ".motion3.json")

        def render(self, width, height, st, at):

            renpy.redraw(self, 0)
            textures = [ renpy.render(d, width, height, st, at) for d in self.textures ]

            for k, v in self.motion.get(st).items():

                kind, key = k

                if kind == "Parameter":
                    self.model.set_parameter(key, v)
                else:
                    self.model.set_part_opacity(key, v)

            return self.model.render(textures)

image hiyori = Live2D("Cubism3SDKforNative/Samples/Res/Hiyori/Hiyori.model3.json", "Hiyori_m01")



label main_menu:
    return

label start:

    $ quick_menu = False

    scene bg washington

    scene expression Solid("#00f8", xysize=(2976, 4175)):
        zoom .16

    show hiyori:
        zoom .16

    pause

    "..."

    return
