define _confirm_quit = False

define e = Character("Eileen", image="eileen")
define l = Character("Lucy", image="lucy")
define a = Character("Augustina", image="augustina")

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
                    if key == "ParamEyeROpen":
                        continue

                    if key == "ParamEyeLOpen":
                        continue

                    self.model.set_parameter(key, v)
                else:
                    self.model.set_part_opacity(key, v)

            return self.model.render(textures)

image hiyori = Live2D("Cubism3SDKforNative/Samples/Res/Hiyori/Hiyori.moc3")


init python:

    import renpy.gl2.gl2draw as gl2draw
    from renpy.gl2.gl2geometry import Mesh
    from renpy.gl2.gl2shadercache import ShaderPart

    ShaderPart("obj", variables="""
    attribute vec3 aNormal;
    varying vec3 vNormal;
""", vertex_110="""
    vNormal = aNormal;
""", fragment_110="""
    float v = vNormal.x / 2 + .5;
    gl_FragColor = vec4(v, v, v, 1.0);
    """);


    def obj_to_mesh(fn):

        rv = Mesh()
        rv.add_attribute("aNormal", 4)

        positions = [ ]
        normals = [ ]

        f = renpy.exports.file(fn)


        count = 300000

        for l in f:
            if (not l) or l[0] == "#":
                continue

            l = l.split()

            if l[0] == 'o':
                pass

            elif l[0] == 'v':
                positions.append((
                    float(l[1]),
                    float(l[2]),
                    float(l[3]),
                    ))

            elif l[0] == 'vn':
                normals.append((
                    float(l[1]),
                    float(l[2]),
                    float(l[3]),
                    ))

            elif l[0] == 'f':

                polygon = [ ]

                for p in l[1:]:
                    idx = p.split('/')

                    polygon.extend(positions[int(idx[0]) - 1])
                    polygon.append(1)
                    polygon.extend(normals[int(idx[2]) - 1])
                    polygon.append(1)

                rv.add_polygon(polygon)

                count -= 1
                if count <= 0:
                    break

        return rv



    class Obj(renpy.Displayable):

        def __init__(self, filename):
            super(Obj, self).__init__()
            self.mesh = obj_to_mesh(filename)

        def render(self, width, height, st, at):

            rv = renpy.Render(width, height)
            rv.mesh = self.mesh
            rv.shaders = ("obj", )
            rv.uniforms = _dict({ })
            rv.properties = _dict(depth=True)
            rv.reverse = renpy.display.matrix.rotate(180, -90, 0)
            rv.reverse = renpy.display.matrix.offset(800, 500, 100 * st) * rv.reverse
            rv.reverse = renpy.display.matrix.perspective(width, height, 100, 1000, 10000) * rv.reverse

            renpy.display.render.redraw(self, 0)


            return rv

# image bg sponza = Obj("sponza.obj")

label main_menu:
    return


label start:

    scene bg washington
    show hiyori:
        zoom .25

    "..."

    return
