register_tile({
    name = "backpack",

    top_texture = "backpack_top.png",
    bottom_texture = "backpack_bottom.png^[transformFY",
    front_texture = "backpack_side.png",
    back_texture = "backpack_side.png^[transformFX",
    left_texture = "backpack_front.png",
    right_texture = "backpack_back.png",

    pixel_box_texture_size = 32,
    pixel_box = {
        {
          5,
          5,
          0,

          27,
          32,
          13
        }
    }
})

register_tile({
    name = "open_backpack",

    -- working with over 1x1 tile node boxes is difficult, so this is a hack
    top_texture = "backpack_open_top.png",
    bottom_texture = "backpack_open_bottom.png",
    front_texture = "backpack_side.png",
    back_texture = "backpack_side.png^[transformFX",
    left_texture = "backpack_open_top.png",
    right_texture = "backpack_open_top.png",

    pixel_box_texture_size = 32,
    pixel_box = {
        -- left main box segment
        {
            27,
            5,
            0,

            27,
            32,
            13
        },

        -- right main box segment
        {
            5,
            5,
            0,

            5,
            32,
            13
        },

        -- bottom main box segment
        {
            5,
            32,
            0,

            27,
            32,
            13
        },

        -- front main box segment
        {
            5,
            16,
            13,

            27,
            32,
            13
        },

        -- rear main box segment
        {
            5,
            5,
            0,

            27,
            32,
            0
        },

        -- bottom of flap
        {
            5,
            5,
            -13,

            27,
            5,
            0
        },

        -- top of flap
        {
            5,
            -11,
            -13,

            27,
            5,
            -13
        },
    }
})