define _confirm_quit = False
define config.gl2 = True
define config.transparent_tile = None

define e = Character("Eileen", image="eileen")
define l = Character("Lucy", image="lucy")

init python:

    import live2d
    import live2dmotion
    import math

    class Live2D(renpy.Displayable):

        def __init__(self, filename, **properties):
            super(Live2D, self).__init__(**properties)
            self.model = live2d.Live2DModel(filename)

            self.textures = [
                renpy.displayable("Cubism3SDKforNative/Samples/Res/Hiyori/Hiyori.2048/texture_00.png"),
                renpy.displayable("Cubism3SDKforNative/Samples/Res/Hiyori/Hiyori.2048/texture_01.png"),
            ]

            self.motion = live2dmotion.Live2DMotion("Cubism3SDKforNative/Samples/Res/Hiyori/motions/Hiyori_m01.motion3.json")

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

image hiyori = Live2D("Cubism3SDKforNative/Samples/Res/Hiyori/Hiyori.moc3")



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
