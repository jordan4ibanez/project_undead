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
    name = "store_isle_shelf_center_empty",
    top_texture = ".png",
    right_texture = ".png",
    left_texture = ".png",
    front_texture = ".png",
    back_texture = ".png",

    pixel_box_texture_size = 32,
    pixel_box = {
        {0,3,5,31,10,15},
        {0,0,0,32,32,32},
    }

})