from libc.stdint cimport intptr_t
from libc.stdlib cimport malloc, free
from libc.string cimport memcpy
from libc.stdio cimport printf

# Enable logging.
cdef void log_function(const char *message):
    print(message)

csmSetLogFunction(log_function)

cdef class AlignedMemory:
    """
    This represents a region of aligned memory. The data is available as


    """

    cdef void *base
    cdef void *data
    cdef int size

    def __init__(self, int size, intptr_t alignment, bytes data):
        self.base = malloc(size + alignment)
        self.data = <void *> (((<intptr_t> self.base) + alignment) & ~(alignment-1))
        self.size = size

        memcpy(self.data, <void *> <unsigned char *> data, len(data))

    def __dealloc__(self):
        free(self.base)


cdef class Model:
    """
    Represents a Live2D model, generated from a MOC.
    """

    cdef AlignedMemory moc_data
    cdef csmMoc *moc
    cdef public csmMocVersion moc_version


    cdef AlignedMemory model_data
    cdef csmModel *model

    cdef int parameter_count
    cdef const char **parameter_ids
    cdef const float *parameter_minimum_values
    cdef const float *parameter_maximum_values
    cdef const float *parameter_default_values
    cdef float *parameter_values

    cdef int part_count
    cdef const char **part_ids
    cdef float *part_opacities
    cdef const int *part_parent_part_indices

    cdef int drawable_count
    cdef const char **drawable_ids
    cdef const csmFlags *drawable_constant_flags
    cdef const csmFlags *drawable_dynamic_flags
    cdef const int *drawable_texture_indices
    cdef const int *drawable_draw_orders
    cdef const int *drawable_render_orders
    cdef const float *drawable_opacities
    cdef const int *drawable_mask_counts
    cdef const int **drawable_masks
    cdef const int *drawable_vertex_counts
    cdef const csmVector2 **drawable_vertex_positions
    cdef const csmVector2 **drawable_vertex_uvs
    cdef const int *drawable_index_counts
    cdef const unsigned short **drawable_indices

    def __init__(self, fn):
        """
        Loads the Live2D model.
        """

        with open(fn, "rb") as f:
            data = f.read()

        # Load the MOC.
        self.moc_data = AlignedMemory(len(data), csmAlignofMoc, data)
        self.moc = csmReviveMocInPlace(self.moc_data.data, self.moc_data.size)

        if self.moc is NULL:
            raise Exception("Could not revive Live2D MOC.")

        self.moc_version = csmGetMocVersion(self.moc_data.data, self.moc_data.size)

        # Make a model.

        cdef unsigned int model_size = csmGetSizeofModel(self.moc)
        self.model_data = AlignedMemory(model_size, csmAlignofModel, b'')
        self.model = csmInitializeModelInPlace(self.moc, self.model_data.data, self.model_data.size)

        if self.model is NULL:
            raise Exception("Could not initialize Live2D Model.")

        # Query the model for pointers to all the things.

        self.parameter_count = csmGetParameterCount(self.model)
        self.parameter_ids = csmGetParameterIds(self.model)
        self.parameter_minimum_values = csmGetParameterMinimumValues(self.model)
        self.parameter_maximum_values = csmGetParameterMaximumValues(self.model)
        self.parameter_default_values = csmGetParameterDefaultValues(self.model)
        self.parameter_values = csmGetParameterValues(self.model)

        self.part_count = csmGetPartCount(self.model)
        self.part_ids = csmGetPartIds(self.model)
        self.part_opacities = csmGetPartOpacities(self.model)
        self.part_parent_part_indices = csmGetPartParentPartIndices(self.model)

        self.drawable_count = csmGetDrawableCount(self.model)
        self.drawable_ids = csmGetDrawableIds(self.model)
        self.drawable_constant_flags = csmGetDrawableConstantFlags(self.model)
        self.drawable_dynamic_flags = csmGetDrawableDynamicFlags(self.model)
        self.drawable_texture_indices = csmGetDrawableTextureIndices(self.model)
        self.drawable_draw_orders = csmGetDrawableDrawOrders(self.model)
        self.drawable_render_orders = csmGetDrawableRenderOrders(self.model)
        self.drawable_opacities = csmGetDrawableOpacities(self.model)
        self.drawable_mask_counts = csmGetDrawableMaskCounts(self.model)
        self.drawable_masks = csmGetDrawableMasks(self.model)
        self.drawable_vertex_counts = csmGetDrawableVertexCounts(self.model)
        self.drawable_vertex_positions = csmGetDrawableVertexPositions(self.model)
        self.drawable_vertex_uvs = csmGetDrawableVertexUvs(self.model)
        self.drawable_index_counts = csmGetDrawableIndexCounts(self.model)
        self.drawable_indices = csmGetDrawableIndices(self.model)
