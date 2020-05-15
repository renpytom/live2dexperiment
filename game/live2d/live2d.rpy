init -999 python:
    import live2d
    Live2D = live2d.Live2D

init -999 python hide:
    renpy.register_shader("live2d.mask", variables="""
        uniform sampler2D uTex0;
        uniform sampler2D uTex1;
        attribute vec4 vPosition;
        attribute vec2 aTexCoord;
        varying vec2 vTexCoord;
        varying vec2 vMaskCoord;
    """, vertex_110="""
        vTexCoord = aTexCoord;
        vMaskCoord = vec2(aPosition.x / 2 + .5, -aPosition.y / 2 + .5);
    """, fragment_110="""
        vec4 color = texture2D(uTex0, vTexCoord);
        vec4 mask = texture2D(uTex1, vMaskCoord);
        gl_FragColor = color * mask.a;
    """)

    renpy.register_shader("live2d.inverted_mask", variables="""
        uniform sampler2D uTex0;
        uniform sampler2D uTex1;
        attribute vec4 vPosition;
        attribute vec2 aTexCoord;
        varying vec2 vTexCoord;
        varying vec2 vMaskCoord;
    """, vertex_110="""
        vTexCoord = aTexCoord;
        vMaskCoord = vec2(aPosition.x / 2 + .5, -aPosition.y / 2 + .5);
    """, fragment_110="""
        vec4 color = texture2D(uTex0, vTexCoord);
        vec4 mask = texture2D(uTex1, vMaskCoord);
        gl_FragColor = color * (1.0 - mask.a);
    """)

    renpy.register_shader("live2d.flip_texture", variables="""
        varying vec2 vTexCoord;
    """, vertex_120="""
        vTexCoord.y = 1.0 - vTexCoord.y;
    """)

