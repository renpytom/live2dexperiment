ctypedef csmVersion (* csmGetVersionType)()
cdef csmGetVersionType csmGetVersion
ctypedef csmMocVersion (* csmGetLatestMocVersionType)()
cdef csmGetLatestMocVersionType csmGetLatestMocVersion
ctypedef csmMocVersion (* csmGetMocVersionType)(const void*, const unsigned int)
cdef csmGetMocVersionType csmGetMocVersion
ctypedef csmLogFunction (* csmGetLogFunctionType)()
cdef csmGetLogFunctionType csmGetLogFunction
ctypedef void (* csmSetLogFunctionType)(csmLogFunction)
cdef csmSetLogFunctionType csmSetLogFunction
ctypedef csmMoc* (* csmReviveMocInPlaceType)(void*, const unsigned int)
cdef csmReviveMocInPlaceType csmReviveMocInPlace
ctypedef unsigned int (* csmGetSizeofModelType)(const csmMoc*)
cdef csmGetSizeofModelType csmGetSizeofModel
ctypedef csmModel* (* csmInitializeModelInPlaceType)(const csmMoc*, void*, const unsigned int)
cdef csmInitializeModelInPlaceType csmInitializeModelInPlace
ctypedef void (* csmUpdateModelType)(csmModel*)
cdef csmUpdateModelType csmUpdateModel
ctypedef void (* csmReadCanvasInfoType)(const csmModel*, csmVector2*, csmVector2*, float*)
cdef csmReadCanvasInfoType csmReadCanvasInfo
ctypedef int (* csmGetParameterCountType)(const csmModel*)
cdef csmGetParameterCountType csmGetParameterCount
ctypedef const char** (* csmGetParameterIdsType)(const csmModel*)
cdef csmGetParameterIdsType csmGetParameterIds
ctypedef const float* (* csmGetParameterMinimumValuesType)(const csmModel*)
cdef csmGetParameterMinimumValuesType csmGetParameterMinimumValues
ctypedef const float* (* csmGetParameterMaximumValuesType)(const csmModel*)
cdef csmGetParameterMaximumValuesType csmGetParameterMaximumValues
ctypedef const float* (* csmGetParameterDefaultValuesType)(const csmModel*)
cdef csmGetParameterDefaultValuesType csmGetParameterDefaultValues
ctypedef float* (* csmGetParameterValuesType)(csmModel*)
cdef csmGetParameterValuesType csmGetParameterValues
ctypedef int (* csmGetPartCountType)(const csmModel*)
cdef csmGetPartCountType csmGetPartCount
ctypedef const char** (* csmGetPartIdsType)(const csmModel*)
cdef csmGetPartIdsType csmGetPartIds
ctypedef float* (* csmGetPartOpacitiesType)(csmModel*)
cdef csmGetPartOpacitiesType csmGetPartOpacities
ctypedef const int* (* csmGetPartParentPartIndicesType)(const csmModel*)
cdef csmGetPartParentPartIndicesType csmGetPartParentPartIndices
ctypedef int (* csmGetDrawableCountType)(const csmModel*)
cdef csmGetDrawableCountType csmGetDrawableCount
ctypedef const char** (* csmGetDrawableIdsType)(const csmModel*)
cdef csmGetDrawableIdsType csmGetDrawableIds
ctypedef const csmFlags* (* csmGetDrawableConstantFlagsType)(const csmModel*)
cdef csmGetDrawableConstantFlagsType csmGetDrawableConstantFlags
ctypedef const csmFlags* (* csmGetDrawableDynamicFlagsType)(const csmModel*)
cdef csmGetDrawableDynamicFlagsType csmGetDrawableDynamicFlags
ctypedef const int* (* csmGetDrawableTextureIndicesType)(const csmModel*)
cdef csmGetDrawableTextureIndicesType csmGetDrawableTextureIndices
ctypedef const int* (* csmGetDrawableDrawOrdersType)(const csmModel*)
cdef csmGetDrawableDrawOrdersType csmGetDrawableDrawOrders
ctypedef const int* (* csmGetDrawableRenderOrdersType)(const csmModel*)
cdef csmGetDrawableRenderOrdersType csmGetDrawableRenderOrders
ctypedef const float* (* csmGetDrawableOpacitiesType)(const csmModel*)
cdef csmGetDrawableOpacitiesType csmGetDrawableOpacities
ctypedef const int* (* csmGetDrawableMaskCountsType)(const csmModel*)
cdef csmGetDrawableMaskCountsType csmGetDrawableMaskCounts
ctypedef const int** (* csmGetDrawableMasksType)(const csmModel*)
cdef csmGetDrawableMasksType csmGetDrawableMasks
ctypedef const int* (* csmGetDrawableVertexCountsType)(const csmModel*)
cdef csmGetDrawableVertexCountsType csmGetDrawableVertexCounts
ctypedef const csmVector2** (* csmGetDrawableVertexPositionsType)(const csmModel*)
cdef csmGetDrawableVertexPositionsType csmGetDrawableVertexPositions
ctypedef const csmVector2** (* csmGetDrawableVertexUvsType)(const csmModel*)
cdef csmGetDrawableVertexUvsType csmGetDrawableVertexUvs
ctypedef const int* (* csmGetDrawableIndexCountsType)(const csmModel*)
cdef csmGetDrawableIndexCountsType csmGetDrawableIndexCounts
ctypedef const unsigned short** (* csmGetDrawableIndicesType)(const csmModel*)
cdef csmGetDrawableIndicesType csmGetDrawableIndices
ctypedef void (* csmResetDrawableDynamicFlagsType)(csmModel*)
cdef csmResetDrawableDynamicFlagsType csmResetDrawableDynamicFlags


cdef bint did_load = False

def load(dll):
    global did_load

    if did_load:
        return True

    did_load = True

    cdef void *object = SDL_LoadObject(dll)
    if not dll:
        return False

    global csmGetVersion
    csmGetVersion = <csmGetVersionType> SDL_LoadFunction(object, "csmGetVersion")
    if not csmGetVersion:
        raise Exception("csmGetVersion not found in Live2D dll " + dll + ".")
    global csmGetLatestMocVersion
    csmGetLatestMocVersion = <csmGetLatestMocVersionType> SDL_LoadFunction(object, "csmGetLatestMocVersion")
    if not csmGetLatestMocVersion:
        raise Exception("csmGetLatestMocVersion not found in Live2D dll " + dll + ".")
    global csmGetMocVersion
    csmGetMocVersion = <csmGetMocVersionType> SDL_LoadFunction(object, "csmGetMocVersion")
    if not csmGetMocVersion:
        raise Exception("csmGetMocVersion not found in Live2D dll " + dll + ".")
    global csmGetLogFunction
    csmGetLogFunction = <csmGetLogFunctionType> SDL_LoadFunction(object, "csmGetLogFunction")
    if not csmGetLogFunction:
        raise Exception("csmGetLogFunction not found in Live2D dll " + dll + ".")
    global csmSetLogFunction
    csmSetLogFunction = <csmSetLogFunctionType> SDL_LoadFunction(object, "csmSetLogFunction")
    if not csmSetLogFunction:
        raise Exception("csmSetLogFunction not found in Live2D dll " + dll + ".")
    global csmReviveMocInPlace
    csmReviveMocInPlace = <csmReviveMocInPlaceType> SDL_LoadFunction(object, "csmReviveMocInPlace")
    if not csmReviveMocInPlace:
        raise Exception("csmReviveMocInPlace not found in Live2D dll " + dll + ".")
    global csmGetSizeofModel
    csmGetSizeofModel = <csmGetSizeofModelType> SDL_LoadFunction(object, "csmGetSizeofModel")
    if not csmGetSizeofModel:
        raise Exception("csmGetSizeofModel not found in Live2D dll " + dll + ".")
    global csmInitializeModelInPlace
    csmInitializeModelInPlace = <csmInitializeModelInPlaceType> SDL_LoadFunction(object, "csmInitializeModelInPlace")
    if not csmInitializeModelInPlace:
        raise Exception("csmInitializeModelInPlace not found in Live2D dll " + dll + ".")
    global csmUpdateModel
    csmUpdateModel = <csmUpdateModelType> SDL_LoadFunction(object, "csmUpdateModel")
    if not csmUpdateModel:
        raise Exception("csmUpdateModel not found in Live2D dll " + dll + ".")
    global csmReadCanvasInfo
    csmReadCanvasInfo = <csmReadCanvasInfoType> SDL_LoadFunction(object, "csmReadCanvasInfo")
    if not csmReadCanvasInfo:
        raise Exception("csmReadCanvasInfo not found in Live2D dll " + dll + ".")
    global csmGetParameterCount
    csmGetParameterCount = <csmGetParameterCountType> SDL_LoadFunction(object, "csmGetParameterCount")
    if not csmGetParameterCount:
        raise Exception("csmGetParameterCount not found in Live2D dll " + dll + ".")
    global csmGetParameterIds
    csmGetParameterIds = <csmGetParameterIdsType> SDL_LoadFunction(object, "csmGetParameterIds")
    if not csmGetParameterIds:
        raise Exception("csmGetParameterIds not found in Live2D dll " + dll + ".")
    global csmGetParameterMinimumValues
    csmGetParameterMinimumValues = <csmGetParameterMinimumValuesType> SDL_LoadFunction(object, "csmGetParameterMinimumValues")
    if not csmGetParameterMinimumValues:
        raise Exception("csmGetParameterMinimumValues not found in Live2D dll " + dll + ".")
    global csmGetParameterMaximumValues
    csmGetParameterMaximumValues = <csmGetParameterMaximumValuesType> SDL_LoadFunction(object, "csmGetParameterMaximumValues")
    if not csmGetParameterMaximumValues:
        raise Exception("csmGetParameterMaximumValues not found in Live2D dll " + dll + ".")
    global csmGetParameterDefaultValues
    csmGetParameterDefaultValues = <csmGetParameterDefaultValuesType> SDL_LoadFunction(object, "csmGetParameterDefaultValues")
    if not csmGetParameterDefaultValues:
        raise Exception("csmGetParameterDefaultValues not found in Live2D dll " + dll + ".")
    global csmGetParameterValues
    csmGetParameterValues = <csmGetParameterValuesType> SDL_LoadFunction(object, "csmGetParameterValues")
    if not csmGetParameterValues:
        raise Exception("csmGetParameterValues not found in Live2D dll " + dll + ".")
    global csmGetPartCount
    csmGetPartCount = <csmGetPartCountType> SDL_LoadFunction(object, "csmGetPartCount")
    if not csmGetPartCount:
        raise Exception("csmGetPartCount not found in Live2D dll " + dll + ".")
    global csmGetPartIds
    csmGetPartIds = <csmGetPartIdsType> SDL_LoadFunction(object, "csmGetPartIds")
    if not csmGetPartIds:
        raise Exception("csmGetPartIds not found in Live2D dll " + dll + ".")
    global csmGetPartOpacities
    csmGetPartOpacities = <csmGetPartOpacitiesType> SDL_LoadFunction(object, "csmGetPartOpacities")
    if not csmGetPartOpacities:
        raise Exception("csmGetPartOpacities not found in Live2D dll " + dll + ".")
    global csmGetPartParentPartIndices
    csmGetPartParentPartIndices = <csmGetPartParentPartIndicesType> SDL_LoadFunction(object, "csmGetPartParentPartIndices")
    if not csmGetPartParentPartIndices:
        raise Exception("csmGetPartParentPartIndices not found in Live2D dll " + dll + ".")
    global csmGetDrawableCount
    csmGetDrawableCount = <csmGetDrawableCountType> SDL_LoadFunction(object, "csmGetDrawableCount")
    if not csmGetDrawableCount:
        raise Exception("csmGetDrawableCount not found in Live2D dll " + dll + ".")
    global csmGetDrawableIds
    csmGetDrawableIds = <csmGetDrawableIdsType> SDL_LoadFunction(object, "csmGetDrawableIds")
    if not csmGetDrawableIds:
        raise Exception("csmGetDrawableIds not found in Live2D dll " + dll + ".")
    global csmGetDrawableConstantFlags
    csmGetDrawableConstantFlags = <csmGetDrawableConstantFlagsType> SDL_LoadFunction(object, "csmGetDrawableConstantFlags")
    if not csmGetDrawableConstantFlags:
        raise Exception("csmGetDrawableConstantFlags not found in Live2D dll " + dll + ".")
    global csmGetDrawableDynamicFlags
    csmGetDrawableDynamicFlags = <csmGetDrawableDynamicFlagsType> SDL_LoadFunction(object, "csmGetDrawableDynamicFlags")
    if not csmGetDrawableDynamicFlags:
        raise Exception("csmGetDrawableDynamicFlags not found in Live2D dll " + dll + ".")
    global csmGetDrawableTextureIndices
    csmGetDrawableTextureIndices = <csmGetDrawableTextureIndicesType> SDL_LoadFunction(object, "csmGetDrawableTextureIndices")
    if not csmGetDrawableTextureIndices:
        raise Exception("csmGetDrawableTextureIndices not found in Live2D dll " + dll + ".")
    global csmGetDrawableDrawOrders
    csmGetDrawableDrawOrders = <csmGetDrawableDrawOrdersType> SDL_LoadFunction(object, "csmGetDrawableDrawOrders")
    if not csmGetDrawableDrawOrders:
        raise Exception("csmGetDrawableDrawOrders not found in Live2D dll " + dll + ".")
    global csmGetDrawableRenderOrders
    csmGetDrawableRenderOrders = <csmGetDrawableRenderOrdersType> SDL_LoadFunction(object, "csmGetDrawableRenderOrders")
    if not csmGetDrawableRenderOrders:
        raise Exception("csmGetDrawableRenderOrders not found in Live2D dll " + dll + ".")
    global csmGetDrawableOpacities
    csmGetDrawableOpacities = <csmGetDrawableOpacitiesType> SDL_LoadFunction(object, "csmGetDrawableOpacities")
    if not csmGetDrawableOpacities:
        raise Exception("csmGetDrawableOpacities not found in Live2D dll " + dll + ".")
    global csmGetDrawableMaskCounts
    csmGetDrawableMaskCounts = <csmGetDrawableMaskCountsType> SDL_LoadFunction(object, "csmGetDrawableMaskCounts")
    if not csmGetDrawableMaskCounts:
        raise Exception("csmGetDrawableMaskCounts not found in Live2D dll " + dll + ".")
    global csmGetDrawableMasks
    csmGetDrawableMasks = <csmGetDrawableMasksType> SDL_LoadFunction(object, "csmGetDrawableMasks")
    if not csmGetDrawableMasks:
        raise Exception("csmGetDrawableMasks not found in Live2D dll " + dll + ".")
    global csmGetDrawableVertexCounts
    csmGetDrawableVertexCounts = <csmGetDrawableVertexCountsType> SDL_LoadFunction(object, "csmGetDrawableVertexCounts")
    if not csmGetDrawableVertexCounts:
        raise Exception("csmGetDrawableVertexCounts not found in Live2D dll " + dll + ".")
    global csmGetDrawableVertexPositions
    csmGetDrawableVertexPositions = <csmGetDrawableVertexPositionsType> SDL_LoadFunction(object, "csmGetDrawableVertexPositions")
    if not csmGetDrawableVertexPositions:
        raise Exception("csmGetDrawableVertexPositions not found in Live2D dll " + dll + ".")
    global csmGetDrawableVertexUvs
    csmGetDrawableVertexUvs = <csmGetDrawableVertexUvsType> SDL_LoadFunction(object, "csmGetDrawableVertexUvs")
    if not csmGetDrawableVertexUvs:
        raise Exception("csmGetDrawableVertexUvs not found in Live2D dll " + dll + ".")
    global csmGetDrawableIndexCounts
    csmGetDrawableIndexCounts = <csmGetDrawableIndexCountsType> SDL_LoadFunction(object, "csmGetDrawableIndexCounts")
    if not csmGetDrawableIndexCounts:
        raise Exception("csmGetDrawableIndexCounts not found in Live2D dll " + dll + ".")
    global csmGetDrawableIndices
    csmGetDrawableIndices = <csmGetDrawableIndicesType> SDL_LoadFunction(object, "csmGetDrawableIndices")
    if not csmGetDrawableIndices:
        raise Exception("csmGetDrawableIndices not found in Live2D dll " + dll + ".")
    global csmResetDrawableDynamicFlags
    csmResetDrawableDynamicFlags = <csmResetDrawableDynamicFlagsType> SDL_LoadFunction(object, "csmResetDrawableDynamicFlags")
    if not csmResetDrawableDynamicFlags:
        raise Exception("csmResetDrawableDynamicFlags not found in Live2D dll " + dll + ".")

    post_init()
