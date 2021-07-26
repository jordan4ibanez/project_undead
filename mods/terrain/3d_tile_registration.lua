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
    name = "generic_store_isle_shelf_center_empty",
    top_texture = "generic_store_isle_shelf_empty_top.png",

    right_texture = "generic_store_isle_shelf_empty_side.png",
    left_texture = "generic_store_isle_shelf_empty_side.png",

    front_texture = "generic_store_isle_shelf_empty_front.png",
    back_texture = "generic_store_isle_shelf_empty_front.png",

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
    name = "generic_store_isle_end_shelf_center_empty",

    top_texture = "1_generic_store_isle_end_shelf_empty_top.png",

    right_texture = "1_generic_store_isle_end_shelf_empty_side.png^[transformFX",
    left_texture = "1_generic_store_isle_end_shelf_empty_side.png",

    front_texture = "1_generic_store_isle_end_shelf_empty_front.png",
    back_texture = "1_generic_store_isle_end_shelf_empty_front.png",

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