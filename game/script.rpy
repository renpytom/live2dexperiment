define _confirm_quit = False
define config.gl2 = True
define config.transparent_tile = None

define e = Character("Eileen", image="eileen")
define l = Character("Lucy", image="lucy")

image hiyori = Live2D("Resources/Hiyori", base=.6)

label main_menu:
    return

label start:

    $ quick_menu = False

    scene bg washington

    show hiyori m01

    pause

    "..."

    return
