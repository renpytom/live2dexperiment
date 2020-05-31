define _confirm_quit = False
define config.gl2 = True
define config.transparent_tile = None

define e = Character("Eileen", image="eileen")
define l = Character("Lucy", image="lucy")

image hiyori = Live2D("Resources/Hiyori", base=.6, height=0.5, aliases={"idle" : "m01"})

image hiyori s1 = Live2D("Resources/Hiyori")
image hiyori s2 = Live2D("Resources/Hiyori", base=.6)
image hiyori s3 = Live2D("Resources/Hiyori", base=.6, top=.1)
image hiyori s4 = Live2D("Resources/Hiyori", base=.6, height=.9)

transform testright:
    xcenter .75
    ypos 1.0

label main_menu:
    return

screen message(t):
    text t:
        yalign 1.0
        size 80
        xmaximum 600
        outlines [ (2, "#000", 0, 0)]

label start:

    $ quick_menu = False

    scene bg washington
    show expression "#0008"

    show hiyori s1 m01 at testright
    show screen message("No arguments")
    pause

    show hiyori s2 m01 at testright
    show screen message("base=.6")
    pause

    show hiyori s3 m01 at testright
    show screen message("base=.6, top=.1")
    pause

    show hiyori s4 m01 at testright
    show screen message("base=.6, height=.9")
    pause

    return

init python:
    config.screen_width = 960
