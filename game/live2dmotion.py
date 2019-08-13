import json
import renpy.exports


class Linear(object):

    def __init__(self, x0, y0, x1, y1):
        self.start = x0
        self.duration = x1 - x0

        self.y0 = y0
        self.y1 = y0


class Step(object):

    def __init__(self, x0, y0, x1, y1):
        self.start = x0
        self.duration = x1 - x0

        self.y0 = y0
        self.y1 = y0


class InvStep(object):

    def __init__(self, x0, y0, x1, y1):
        self.start = x0
        self.duration = x1 - x0

        self.y0 = y0
        self.y1 = y0


class Bezier(object):

    def __init__(self, x0, y0, x1, y1, x2, y2, x3, y3):
        self.start = x0
        self.duration = x3 - x0

        self.x0 = 0
        self.x1 = x1 - x0
        self.x2 = x2 - x0
        self.x3 = x3 - x0

        self.y0 = y0
        self.y1 = y1
        self.y2 = y2
        self.y3 = y3


class Live2DMotion(object):

    def __init__(self, filename):
        j = json.load(renpy.exports.file(filename))

        self.duration = j["Meta"]["Duration"]
        self.curves = { }

        for i in j["Curves"]:
            target = i["Target"]
            name = i["Id"]
            s = i["Segments"]

            x0 = s.pop(0)
            y0 = s.pop(0)

            segments = [ ]

            while s:

                kind = s.pop(0)

                if kind == 0:
                    x = s.pop(0)
                    y = s.pop(0)

                    self.x0 = x0
                    self.x1 = x1

                    segments.append(Linear(x0, y0, x, y))

                elif kind == 1:
                    x1 = s.pop(0)
                    y1 = s.pop(0)
                    x2 = s.pop(0)
                    y2 = s.pop(0)
                    x = s.pop(0)
                    y = s.pop(0)

                    segments.append(Bezier(x0, y0, x1, y1, x2, y2, x, y))

                elif kind == 2:
                    x = s.pop(0)
                    y = s.pop(0)

                    segments.append(Step(x0, y0, x, y))

                elif kind == 3:
                    x = s.pop(0)
                    y = s.pop(0)

                    segments.append(InvStep(x0, y0, x, y))

                else:
                    raise Exception("Unknown kind.")

                x0 = x
                y0 = y

            self.curves[target, name] = segments

        print(self.curves.keys())
