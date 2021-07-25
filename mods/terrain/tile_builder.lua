local register_node = minetest.register_node

--this is a wrapper for the build in Minetest library, can be used to optimize nodes, now called tiles since game is mostly 2D in nature
function register_tile(def)
    register_node(":" .. (def.name or "you've failed to name your tile"), {
        description = def.description,
        tiles = {
            def.top_texture or "invisible.png",
            def.bottom_texture or "invisible.png",
            def.front_texture or "invisible.png",
            def.back_texture or "invisible.png",
            def.right_texture or "invisible.png",
            def.left_texture or "invisible.png",
        },
        paramtype2 = "color",
        pointable = def.pointable or (build_mode or false),
        diggable = false,
        climbable = def.climbable,
        is_ground_content = false,
        buildable_to = false,
        floodable = false,
        liquidtype = nil,
        damage_per_second = def.dps or nil,
        waving = def.waving,
    })
end