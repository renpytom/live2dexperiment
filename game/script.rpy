define _confirm_quit = False
define config.gl2 = True
define config.transparent_tile = None

define e = Character("Eileen", image="eileen")
define l = Character("Lucy", image="lucy")

image hiyori = Live2D("Resources/Hiyori", base=.6, aliases={"idle" : "m01"})

image hiyori s1 = Live2D("Resources/Hiyori")
image hiyori s2 = Live2D("Resources/Hiyori", base=.6)
image hiyori s3 = Live2D("Resources/Hiyori", base=.6, top=0.07)
image hiyori s4 = Live2D("Resources/Hiyori", base=.6, height=.9)

label main_menu:
    return

screen message(t):
    text t:
        yalign 1.0
        size 70
        xmaximum 1000
        outlines [ (2, "#000", 0, 0)]

transform right:
    xcenter .8
    yalign 1.0

label start:

    $ quick_menu = False

    scene bg washington
    show expression "#0008"

    show hiyori m01 at center
    pause
    show hiyori m03 m01 at center
    pause

    "..."

    return

