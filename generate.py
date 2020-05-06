#!/usr/bin/env python3

import sys

FUNCTIONS = """\
csmVersion csmGetVersion()
csmMocVersion csmGetLatestMocVersion()
csmMocVersion csmGetMocVersion(const void* address, const unsigned int size)
csmLogFunction csmGetLogFunction()
void csmSetLogFunction(csmLogFunction handler)
csmMoc* csmReviveMocInPlace(void* address, const unsigned int size)
unsigned int csmGetSizeofModel(const csmMoc* moc)
csmModel* csmInitializeModelInPlace(const csmMoc* moc, void* address, const unsigned int size)
void csmUpdateModel(csmModel* model)
void csmReadCanvasInfo(const csmModel* model, csmVector2* outSizeInPixels, csmVector2* outOriginInPixels, float* outPixelsPerUnit)
int csmGetParameterCount(const csmModel* model)
const char** csmGetParameterIds(const csmModel* model)
const float* csmGetParameterMinimumValues(const csmModel* model)
const float* csmGetParameterMaximumValues(const csmModel* model)
const float* csmGetParameterDefaultValues(const csmModel* model)
float* csmGetParameterValues(csmModel* model)
int csmGetPartCount(const csmModel* model)
const char** csmGetPartIds(const csmModel* model)
float* csmGetPartOpacities(csmModel* model)
const int* csmGetPartParentPartIndices(const csmModel* model)
int csmGetDrawableCount(const csmModel* model)
const char** csmGetDrawableIds(const csmModel* model)
const csmFlags* csmGetDrawableConstantFlags(const csmModel* model)
const csmFlags* csmGetDrawableDynamicFlags(const csmModel* model)
const int* csmGetDrawableTextureIndices(const csmModel* model)
const int* csmGetDrawableDrawOrders(const csmModel* model)
const int* csmGetDrawableRenderOrders(const csmModel* model)
const float* csmGetDrawableOpacities(const csmModel* model)
const int* csmGetDrawableMaskCounts(const csmModel* model)
const int** csmGetDrawableMasks(const csmModel* model)
const int* csmGetDrawableVertexCounts(const csmModel* model)
const csmVector2** csmGetDrawableVertexPositions(const csmModel* model)
const csmVector2** csmGetDrawableVertexUvs(const csmModel* model)
const int* csmGetDrawableIndexCounts(const csmModel* model)
const unsigned short** csmGetDrawableIndices(const csmModel* model)
void csmResetDrawableDynamicFlags(csmModel* model)
"""


class Function:

    def __init__(self, l):

        rest = l.rpartition(")")[0]
        rest, _, args = rest.rpartition("(")
        types, _, name = rest.rpartition(" ")

        self.type = types
        self.name = name

        self.args = [ ]

        argtypes = [ ]

        for i in args.split(","):
            argtype, _, argname = i.strip().rpartition(" ")
            argtypes.append(argtype)

        self.argtypes = ", ".join(argtypes)

    def codegen_define(self, f):
        f.write(f"ctypedef {self.type} (* {self.name}Type)({self.argtypes})\n")
        f.write(f"cdef {self.name}Type {self.name}\n")

    def codegen_load(self, f):
        f.write(f"    global {self.name}\n")
        f.write(f"""\
    {self.name} = <{self.name}Type> SDL_LoadFunction(object, \"{self.name}\")
    if not {self.name}:
        raise Exception("{self.name} not found in Live2D dll " + dll + ".")
""")


    def __repr__(self):
        return f"{self.type} {self.name}({self.argtypes})"

def init():

    rv = [ ]

    for i in FUNCTIONS.split("\n"):
        i = i.strip()
        if not i:
            continue

        rv.append(Function(i))

    return rv

def main():
    functions = init()

    f = sys.stdout

    for func in functions:
        func.codegen_define(f)

    f.write("""

cdef bint did_load = False

def load(dll):
    global did_load

    if did_load:
        return True

    did_load = True

    cdef void *object = SDL_LoadObject(dll)
    if not dll:
        return False

""")



    for func in functions:
        func.codegen_load(f)

    f.write("""
    post_init()
""")

if __name__ == "__main__":
    main()
