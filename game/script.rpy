define _confirm_quit = False

define e = Character("Eileen", image="eileen")
define l = Character("Lucy", image="lucy")
define a = Character("Augustina", image="augustina")

init python:

    import live2d
    import math

    class Live2D(renpy.Displayable):

        def __init__(self, filename, **properties):
            super(Live2D, self).__init__(**properties)
            self.model = live2d.Live2DModel(filename)

            self.textures = [
                renpy.displayable("./Cubism3SDKforNative/Samples/Res/Hiyori/Hiyori.2048/texture_00.png"),
                renpy.displayable("./Cubism3SDKforNative/Samples/Res/Hiyori/Hiyori.2048/texture_01.png"),
            ]

            self.model.set_part_opacity("PartArmA", 0.0)

            pax = self.model.parameters["ParamAngleX"]
            print(pax.minimum, pax.default, pax.maximum)


        def render(self, width, height, st, at):

            angle = 30 * math.sin(st)

            renpy.redraw(self, 0)
            textures = [ renpy.render(d, width, height, st, at) for d in self.textures ]

            self.model.set_parameter("ParamAngleX", angle)


            return self.model.render(textures)

image hiyori = Live2D("./Cubism3SDKforNative/Samples/Res/Hiyori/Hiyori.moc3")


label main_menu:
    return


label start:

    scene bg washington
    show hiyori

    "..."

    return
