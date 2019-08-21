from libc.stdint cimport intptr_t
from libc.stdlib cimport malloc, free
from libc.string cimport memcpy
from libc.stdio cimport printf

from renpy.gl2.gl2geometry cimport Mesh, Polygon
from renpy.display.matrix cimport Matrix
from renpy.display.render cimport Render


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

class Parameter(object):
    """
    Represents the information known about a parameter.
    """

    def __init__(self, index, name, minimum, maximum, default):
        self.index = index
        self.name = name
        self.minimum = minimum
        self.maximum = maximum
        self.default = default

class Part(object):

    def __init__(self, index, name):
        self.index = index
        self.name = name

cdef class Live2DModel:
    """
    Represents a Live2D model, generated from a MOC.
    """

    cdef AlignedMemory moc_data
    cdef csmMoc *moc
    cdef public csmMocVersion moc_version


    cdef AlignedMemory model_data
    cdef csmModel *model

    cdef csmVector2 pixel_size
    cdef csmVector2 pixel_origin
    cdef float pixels_per_unit

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

    cdef public dict parameters
    cdef public dict parts

    def __init__(self, fn):
        """
        Loads the Live2D model.
        """

        import renpy.exports

        data = renpy.exports.file(fn).read()

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

        csmReadCanvasInfo(self.model, &(self.pixel_size), &(self.pixel_origin), &(self.pixels_per_unit))

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

        self.parameters = { }

        for 0 <= i < self.parameter_count:
            name = self.parameter_ids[i]
            self.parameters[name] = Parameter(
                i, name,
                self.parameter_minimum_values[i],
                self.parameter_maximum_values[i],
                self.parameter_default_values[i],
                )

        self.parts = { }

        for 0 <= i < self.part_count:
            name = self.part_ids[i]
            self.parts[name] = Part(i, name)

    def set_part_opacity(self, name, value):
        part = self.parts[name]
        self.part_opacities[part.index] = value

    def set_parameter(self, name, value):
        parameter = self.parameters[name]
        self.parameter_values[parameter.index] = value

    cdef drawable_to_mesh(Live2DModel self, int drawable):
        cdef csmVector2 *vertex_positions = self.drawable_vertex_positions[drawable]
        cdef csmVector2 *vertex_uvs = self.drawable_vertex_uvs[drawable]
        cdef unsigned short *indices = self.drawable_indices[drawable]
        cdef int index_count = self.drawable_index_counts[drawable]

        cdef Mesh mesh = Mesh()
        mesh.add_attribute("aTexCoord", 2)

        cdef int i = 0
        cdef int idx = 0

        cdef Polygon p
        cdef float *d

        while i < index_count:

            p = Polygon(6, 3, None)
            p.points = 3
            d = p.data

            idx = indices[i]
            d[0] = vertex_positions[idx].X
            d[1] = vertex_positions[idx].Y
            d[2] = 0
            d[3] = 1
            d[4] = vertex_uvs[idx].X
            d[5] = 1.0 - vertex_uvs[idx].Y
            i += 1

            idx = indices[i]
            d[6] = vertex_positions[idx].X
            d[7] = vertex_positions[idx].Y
            d[8] = 0
            d[9] = 1
            d[10] = vertex_uvs[idx].X
            d[11] = 1.0 - vertex_uvs[idx].Y
            i += 1

            idx = indices[i]
            d[12] = vertex_positions[idx].X
            d[13] = vertex_positions[idx].Y
            d[14] = 0
            d[15] = 1
            d[16] = vertex_uvs[idx].X
            d[17] = 1.0 - vertex_uvs[idx].Y
            i += 1

            mesh.polygons.append(p)
            mesh.points += 3

        return mesh

    def render(self, textures):

        cdef Mesh mesh
        cdef Render r
        cdef Render rv

        w = self.pixel_size.X
        h = self.pixel_size.Y

        shaders = ("renpy.texture",)
        uniforms = None # { "uSolidColor" : (0.5, 0.0, 0.0, 1.0) }

        cdef Matrix scale = Matrix([
            self.pixels_per_unit, 0, 0, self.pixel_origin.X,
            0, -self.pixels_per_unit, 0, self.pixel_origin.Y,
            0, 0, 1, 0,
            0, 0, 0, 1,
            ])

        cdef int i

        csmUpdateModel(self.model)

        rv = Render(w, h)
        # rv.fill("#f008")

        renders = [ ]

        for 0 <= i < self.drawable_count:

            if not self.drawable_dynamic_flags[i] & csmIsVisible:
                continue

            mesh = self.drawable_to_mesh(i);
            mesh.multiply_matrix_inplace(scale)

            r = Render(w, h)
            r.mesh = mesh
            r.shaders = shaders
            r.uniforms = uniforms
            r.alpha = self.drawable_opacities[i]

            r.blit(textures[self.drawable_texture_indices[i]], (0, 0))

            renders.append((self.drawable_render_orders[i], r))

        renders.sort()

        for t in renders:
            rv.blit(t[1], (0, 0))

        return rv



