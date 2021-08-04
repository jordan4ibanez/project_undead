-- free up memory
minetest.register_entity(":__builtin:item", {
    initial_properties = nil,
    set_item = nil,
    on_activate = nil,
    itemstring = nil,
    moving_state = nil,
    physical_state = nil,
    age = nil,
    get_staticdata = nil,
    try_merge_with = nil,
    enable_physics = nil,
    disable_physics = nil,
    on_step = nil,
    on_punch = nil
})

