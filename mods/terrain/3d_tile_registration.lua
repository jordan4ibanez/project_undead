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
    name = "chainlink_fence",

    left_texture = "chainlink_fence.png",
    right_texture = "chainlink_fence.png",
    front_texture = "chainlink_fence.png",
    back_texture = "chainlink_fence.png",

    fence = true,

    fence_connections = {"chainlink_fence", "chainlink_fence_pole"}
})

register_tile({
    name = "chainlink_fence_pole",
    all_texture = "chainlink_fence_pole.png",
    pole = true,
})

register_tile({
    name = "guardrail",

    all_texture = "guardrail.png",

    pixel_box_specific = {
        type = "connected",
        fixed = { { -0.1, -0.5, -0.1, 0.1, 0.5, 0.1 }, },
        connect_front = {
            { 0, -0.1875, -0.5, 0, 0.4375, 0 },
            { -0.0625, 0.1875, -0.5, 0.0625, 0.3125, 0 },
            { -0.0625, -0.0625, -0.5, 0.0625, 0.0625, 0 },
        }, -- z-
        connect_back = {
            { 0, -0.1875, 0.5, 0, 0.4375, 0 },
            { -0.0625, 0.1875, 0.5, 0.0625, 0.3125, 0 },
            { -0.0625, -0.0625, 0.5, 0.0625, 0.0625, 0 },
        }, -- z+
        connect_left = {
            { -0.5, -0.1875, 0, 0, 0.4375, 0 },
            { -0.5, 0.1875, -0.0625, 0, 0.3125, 0.0625 },
            { -0.5, -0.0625, -0.0625, 0, 0.0625, 0.0625 },
        }, -- x-
        connect_right = {
            { 0.5, -0.1875, 0, 0, 0.4375, 0 },
            { 0.5, 0.1875, -0.0625, 0, 0.3125, 0.0625 },
            { 0.5, -0.0625, -0.0625, 0, 0.0625, 0.0625 },
        }, -- x+
    },

    connects_to = {"guardrail"},
    climb_over = true,
})

register_tile({
    name = "jersey_barrier",
    all_texture = "concrete.png",
    pixel_box_specific = {
        type = "connected",
        fixed = { { -0.35, -0.5, -0.35, 0.35, -0.4, 0.35 }, { -0.15, -0.5, -0.15, 0.15, 0.5, 0.15 } },
        connect_front = { { -0.35, -0.5, -0.5, 0.35, -0.4, 0.35 }, { -0.15, -0.5, -0.5, 0.15, 0.5, 0.15 } }, -- z-
        connect_back = { { -0.35, -0.5, -0.35, 0.35, -0.4, 0.5 }, { -0.15, -0.5, -0.15, 0.15, 0.5, 0.5 } }, -- z+
        connect_left = { { -0.5, -0.5, -0.35, 0.35, -0.4, 0.35 }, { -0.5, -0.5, -0.15, 0.15, 0.5, 0.15 } }, -- x-
        connect_right = { { -0.35, -0.5, -0.35, 0.5, -0.4, 0.35 }, { -0.15, -0.5, -0.15, 0.5, 0.5, 0.15 } }, -- x+
    },
    connects_to = {"jersey_barrier"},
    climb_over = true,
})

register_tile({
    name = "gas_pump_bottom",

    top_texture = "gas_pump_top_side.png",
    bottom_texture = "gas_pump_top_side.png",

    right_texture = "gas_pump_bottom_side.png",
    left_texture = "gas_pump_bottom_side.png",

    front_texture = "gas_pump_bottom_front.png",
    back_texture = "gas_pump_bottom_front.png",

    pixel_box_texture_size = 32,
    pixel_box = {
        {
            7,
            0,
            0,

            25,
            32,
            32
        },
    }
})

register_tile({
    name = "gas_pump_top",

    top_texture = "gas_pump_top_side.png",
    bottom_texture = "gas_pump_top_side.png",

    right_texture = "gas_pump_top_side.png",
    left_texture = "gas_pump_top_side.png",

    front_texture = "gas_pump_top_front.png",
    back_texture = "gas_pump_top_front.png",

    pixel_box_texture_size = 32,
    pixel_box = {
        -- base
        {
            7,
            17,
            0,

            25,
            32,
            32
        },

        -- left support
        {
            7,
            0,
            0,

            25,
            17,
            2
        },

        -- right support
        {
            7,
            0,
            30,

            25,
            17,
            32
        },

        -- cover support
        {
            7,
            0,
            0,

            25,
            2,
            32
        },

        -- price sign
        {
            16,
            5,
            4,

            16,
            17,
            28
        },
    }
})

register_tile({
    name = "generic_counter",
    all_texture = "generic_counter.png",
})

register_tile({
    name = "outer_wall_blue",
    all_texture = "outer_wall_blue.png"
})

register_tile({
    name = "outer_wall_black",
    all_texture = "outer_wall_black.png"
})

register_tile({
    name = "outer_wall_green",
    all_texture = "outer_wall_green.png"
})

register_tile({
    name = "outer_wall_grey",
    all_texture = "outer_wall_grey.png"
})

register_tile({
    name = "outer_wall_orange",
    all_texture = "outer_wall_orange.png"
})

register_tile({
    name = "outer_wall_red",
    all_texture = "outer_wall_red.png"
})

register_tile({
    name = "outer_wall_white",
    all_texture = "outer_wall_white.png"
})

register_tile({
    name = "outer_wall_yellow",
    all_texture = "outer_wall_yellow.png"
})

register_tile({
    name = "ladder",
    front_texture = "ladder.png",
    back_texture = "ladder.png",

    left_texture = "ladder.png",
    right_texture = "ladder.png",

    top_texture = "ladder_top.png",
    bottom_texture = "ladder_top.png^[transformFY",


    pixel_box_texture_size = 32,
    pixel_box = {
        -- right side rail
        {
            0,
            0,
            0,

            3,
            32,
            3
        },

        -- left side rail
        {
            29,
            0,
            0,

            32,
            32,
            3
        },

        -- top rung
        {
            3,
            7,
            0,

            29,
            9,
            2
        },

        -- bottom rung
        {
            3,
            23,
            0,

            29,
            25,
            2
        },
    }

})