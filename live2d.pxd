cdef extern from "Live2DCubismCore.h":

    ctypedef struct csmMoc
    ctypedef struct csmModel
    ctypedef unsigned int csmVersion

    enum:
        csmAlignofMoc
        csmAlignofModel

    enum:
        csmBlendAdditive
        csmBlendMultiplicative
        csmIsDoubleSided

    enum:
        csmIsVisible
        csmVisibilityDidChange
        csmOpacityDidChange
        csmDrawOrderDidChange
        csmRenderOrderDidChange
        csmVertexPositionsDidChange

    ctypedef unsigned char csmFlags

    enum:
        csmMocVersion_Unknown
        csmMocVersion_30
        csmMocVersion_33

    ctypedef unsigned int csmMocVersion

    ctypedef struct csmVector2:
        float X
        float Y

    ctypedef void (*csmLogFunction)(const char* message)

    csmVersion csmGetVersion()

    csmMocVersion csmGetLatestMocVersion()

    csmMocVersion csmGetMocVersion(const void* address, const unsigned int size)

    csmLogFunction csmGetLogFunction()

    void csmSetLogFunction(csmLogFunction handler)

    csmMoc* csmReviveMocInPlace(void* address, const unsigned int size)

    unsigned int csmGetSizeofModel(const csmMoc* moc)

    csmModel* csmInitializeModelInPlace(
        const csmMoc* moc,
        void* address,
        const unsigned int size)

    void csmUpdateModel(csmModel* model)

    void csmReadCanvasInfo(const csmModel* model,
                                  csmVector2* outSizeInPixels,
                                  csmVector2* outOriginInPixels,
                                  float* outPixelsPerUnit)

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
