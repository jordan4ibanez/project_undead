register_tile({
    name = "concrete",
    all_texture = "concrete.png"
})

register_tile({
    name = "outer_wall_blue",
    all_texture = "outer_wall_blue.png"
})

register_tile({
    name = "gas_n_go_sign",
    top_texture = "gas_n_go_sign_edge.png",
    bottom_texture = "gas_n_go_sign_edge.png",
    left_texture = "gas_n_go_sign_edge.png",
    front_texture = "gas_n_go_sign_1.png",
    back_texture = "gas_n_go_sign_2.png",
    rotation = true,
})


register_tile({
    name = "pole_blue",
    all_texture = "pole_blue.png",
    pole = true,
})

register_tile({
    name = "generic_gas_station_edge",
    all_texture = "generic_gas_station_edge.png",
})

register_tile({
    name = "generic_gas_station_roof",
    top_texture = "generic_gas_station_roof.png",
    bottom_texture = "generic_gas_station_roof.png",
    left_texture = "generic_gas_station_edge.png^[transformR90",
    right_texture = "generic_gas_station_edge.png^[transformR90",
    front_texture = "generic_gas_station_edge.png^[transformR90",
    back_texture = "generic_gas_station_edge.png^[transformR90",
})

register_tile({
    name = "glass",
    all_texture = "glass.png",
    glass = true,
})


register_tile({
    name = "generic_store_isle_empty",
    top_texture = "generic_store_isle_empty_top.png",
    bottom_texture = "generic_store_isle_empty_top.png",

    right_texture = "generic_store_isle_empty_side.png",
    left_texture = "generic_store_isle_empty_side.png",

    front_texture = "generic_store_isle_empty_front.png",
    back_texture = "generic_store_isle_empty_front.png",

    pixel_box_texture_size = 32,
    pixel_box = {
        -- center column
        {
            15,
            0,
            0,

            17,
            32,
            32
        },

        -- bottom shelf
        {
            0,
            30,
            0,

            32,
            32,
            32
        },


        -- top shelf
        {
            0,
            14,
            0,

            32,
            16,
            32
        },
    }

})


register_tile({
    name = "generic_store_isle_end_empty",

    top_texture = "generic_store_isle_end_empty_top.png",
    bottom_texture = "generic_store_isle_end_empty_top.png",

    right_texture = "generic_store_isle_end_empty_side.png^[transformFX",
    left_texture = "generic_store_isle_end_empty_side.png",

    front_texture = "generic_store_isle_end_empty_front.png",
    back_texture = "generic_store_isle_end_empty_front.png",

    pixel_box_texture_size = 32,
    pixel_box = {
        -- center column
        {
            0,
            0,
            0,

            2,
            32,
            32
        },

        -- bottom shelf
        {
            0,
            30,
            0,

            16,
            32,
            32
        },


        -- top shelf
        {
            0,
            14,
            0,

            16,
            16,
            32
        },
    }

})

register_tile({
    name = "generic_store_isle_stocked",

    top_texture = "generic_store_isle_stocked_top.png",
    bottom_texture = "generic_store_isle_empty_top.png",

    right_texture = "generic_store_isle_stocked_side.png",
    left_texture = "generic_store_isle_stocked_side.png",

    front_texture = "generic_store_isle_stocked_front.png",
    back_texture = "generic_store_isle_stocked_front.png",

    pixel_box_texture_size = 32,
    pixel_box = {

        -- center column
        {
            15,
            0,
            0,

            17,
            32,
            32
        },

        -- bottom shelf
        {
            0,
            30,
            0,

            32,
            32,
            32
        },

        -- top shelf
        {
            0,
            14,
            0,

            32,
            16,
            32
        },

        -- item - top left

        {
            10,
            1,
            3,

            22,
            14,
            12
        },

        -- item - bottom left

        {
            10,
            17,
            3,

            22,
            30,
            12
        },

        -- item - top right

        {
            10,
            1,
            20,

            22,
            14,
            29
        },

        -- item - bottom right

        {
            10,
            17,
            20,

            22,
            30,
            29
        },
    }
})


register_tile({
    name = "generic_store_isle_end_stocked",

    top_texture = "generic_store_isle_end_stocked_top.png",
    bottom_texture = "generic_store_isle_end_stocked_top.png",

    right_texture = "generic_store_isle_end_stocked_side.png^[transformFX",
    left_texture = "generic_store_isle_end_stocked_side.png",

    front_texture = "generic_store_isle_end_empty_front.png",
    back_texture = "generic_store_isle_end_stocked_front.png",

    pixel_box_texture_size = 32,
    pixel_box = {
        -- center column
        {
            0,
            0,
            0,

            2,
            32,
            32
        },

        -- bottom shelf
        {
            0,
            30,
            0,

            16,
            32,
            32
        },


        -- top shelf
        {
            0,
            14,
            0,

            16,
            16,
            32
        },

        -- item - top left

        {
            2,
            1,
            3,

            7,
            14,
            12
        },

        -- item - bottom left

        {
            2,
            17,
            3,

            7,
            30,
            12
        },

        -- item - top right

        {
            2,
            1,
            20,

            7,
            14,
            29
        },

        -- item - bottom right

        {
            2,
            17,
            20,

            7,
            30,
            29
        },
    }
})


register_tile({
    name = "generic_store_isle_end_stocked",

    fence = true,
})