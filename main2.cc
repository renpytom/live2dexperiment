#include <Live2DCubismCore.h>
#include <stdio.h>
#include <stdlib.h>


void logFunction(const char *message) {
    printf("%s\n", message);
}

int main(int argc, char **argv) {
    csmVersion version = csmGetVersion();
    csmVersion major = (version & 0xFF000000) >> 24;
    csmVersion minor = (version & 0x00FF0000) >> 16;
    csmVersion patch = (version & 0x0000FFFF);

    printf("CSM version: %d.%d.%d\n", major, minor, patch);

    csmMocVersion mocLatestVersion = csmGetLatestMocVersion();

    printf("CSM latest Moc Version: %d\n", mocLatestVersion);

    csmSetLogFunction(logFunction);

    FILE *f = fopen("Cubism3SDKforNative/Samples/Res/Hiyori/Hiyori.moc3", "rb");

    fseek(f, 0, SEEK_END);
    long mocLength = ftell(f);
    fseek(f, 0, SEEK_SET);

    printf("mocLength: %ld\n", mocLength);

    // mocLength rounded up to the alignment.
    long alignedLength = ((mocLength / csmAlignofMoc) + 1) * csmAlignofMoc;
    void *mocData = aligned_alloc(csmAlignofMoc, alignedLength);

    fread(mocData, mocLength, 1, f);
    fclose(f);

    csmMocVersion mocVersion = csmGetMocVersion(mocData, mocLength);

    printf("Actual Moc Version: %d\n", mocVersion);

    csmMoc *moc = csmReviveMocInPlace(mocData, mocLength);

    unsigned int modelSize = csmGetSizeofModel(moc);

    printf("modelSize: %d\n", modelSize);

    alignedLength = ((mocLength / csmAlignofModel) + 1) * csmAlignofModel;
    void *modelData = aligned_alloc(csmAlignofModel, alignedLength);

    csmModel *model = csmInitializeModelInPlace(moc, modelData, modelSize);

    csmVector2 outSizeInPixels;
    csmVector2 outOriginInPixels;
    float outPixelsPerUnit;

    csmReadCanvasInfo(model, &outSizeInPixels, &outOriginInPixels, &outPixelsPerUnit);
    printf("outSizeInPixels=%f,%f\n", outSizeInPixels.X, outSizeInPixels.Y);
    printf("outOriginInPixels=%f,%f\n", outOriginInPixels.X, outOriginInPixels.Y);
    printf("outPixelsPerUnit=%f\n", outPixelsPerUnit);

    int parameterCount = csmGetParameterCount(model);
    const char **parameterIds = csmGetParameterIds(model);
    const float *parameterMin = csmGetParameterMinimumValues(model);
    const float *parameterMax = csmGetParameterMaximumValues(model);
    const float *parameterDefault = csmGetParameterDefaultValues(model);
    float *parameterCur = csmGetParameterValues(model);


    for (int i = 0; i < parameterCount; i++) {
        printf("  %02d: %32s | %f %f %f %f\n", i, parameterIds[i], parameterMin[i], parameterMax[i], parameterDefault[i], parameterCur[i]);
    }

    csmUpdateModel(model);

    int drawableCount = csmGetDrawableCount(model);
    const char **drawableIds = csmGetDrawableIds(model);
    const csmFlags *constantFlags = csmGetDrawableConstantFlags(model);
    const csmFlags *dynamicFlags =  csmGetDrawableDynamicFlags(model);
    const int *vertexCounts = csmGetDrawableVertexCounts(model);
    const int *indexCounts = csmGetDrawableIndexCounts(model);
    const int *textureIndex = csmGetDrawableTextureIndices(model);
    const int *maskCounts = csmGetDrawableMaskCounts(model);
    const int **masks = csmGetDrawableMasks(model);
    const int *renderOrder = csmGetDrawableRenderOrders(model);
    const float *opacity = csmGetDrawableOpacities(model);
    const csmVector2** vertexPositions = csmGetDrawableVertexPositions(model);
    const csmVector2** vertexUvs = csmGetDrawableVertexUvs(model);
    const unsigned short** indices = csmGetDrawableIndices(model);


    for (int i = 0; i < drawableCount; i++) {
        printf("  %03d: %d %02x %02x %s %d %d %f ord %d alpha %f\n",
            i, textureIndex[i], constantFlags[i],  dynamicFlags[i],
            drawableIds[i], vertexCounts[i], indexCounts[i], indexCounts[i] / 3.0,
            renderOrder[i], opacity[i]);

        for (int j = 0; j < maskCounts[i]; j++) {
            printf("        masked by: %d\n", masks[i][j]);
        }

        for (int j = 0; j < vertexCounts[i]; j++) {
            printf("        %d: %f, %f : %f, %f\n", j,
                vertexPositions[i][j].X, vertexPositions[i][j].Y,
                vertexUvs[i][j].X, vertexUvs[i][j].Y);
        }

    }




}
