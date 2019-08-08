define _confirm_quit = False

define e = Character("Eileen", image="eileen")
define l = Character("Lucy", image="lucy")
define a = Character("Augustina", image="augustina")

init python:

    import live2d

    class Live2D(renpy.Displayable):

        def __init__(self, filename, **properties):
            super(Live2D, self).__init__(**properties)
            self.model = live2d.Live2DModel(filename)

        def render(self, width, height, st, at):
            return self.model.render()

image hiyori = Live2D("./Cubism3SDKforNative/Samples/Res/Hiyori/Hiyori.moc3")


label main_menu:
    return


label start:

    scene bg washington
    show hiyori

    "..."

    return
