local register_node = minetest.register_node

--this is a wrapper for the build in Minetest library, can be used to optimize nodes, now called tiles since game is mostly 2D in nature
function register_tile(def)
    local param2
    if (def.rotation) then
        param2 = "facedir"
    end

    local tiles

    if (def.all_texture) then
        tiles = {def.all_texture}
    else
        tiles = {
            def.top_texture or "invisible.png",
            def.bottom_texture or "invisible.png",
            def.front_texture or "invisible.png",
            def.back_texture or "invisible.png",
            def.right_texture or "invisible.png",
            def.left_texture or "invisible.png",
        }
    end

    register_node(":" .. (def.name or "you've failed to name your tile"), {
        description = def.description,
        tiles = tiles,
        paramtype2 = param2,
        pointable = def.pointable or (build_mode or false),
        diggable = build_mode or false,
        climbable = def.climbable,
        is_ground_content = false,
        buildable_to = false,
        floodable = false,
        liquidtype = nil,
        damage_per_second = def.dps or nil,
        waving = def.waving,
        groups = { editor = 1 }
    })
end