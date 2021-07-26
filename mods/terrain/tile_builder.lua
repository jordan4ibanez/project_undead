local register_node = minetest.register_node

--this is a wrapper for the build in Minetest library, can be used to optimize nodes, now called tiles since game is mostly 2D in nature
function register_tile(def)
    local param2
    local drawtype
    local tiles
    local node_box
    local sunlight_propagates

    -- digest rotation parameter
    if (def.rotation) then
        param2 = "facedir"
    end

    -- allow for single texture definition
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


    -- easy way to define poles
    if (def.pole) then
        sunlight_propagates = true
        drawtype = "nodebox"
        node_box = {
            type = "fixed",
            fixed = {
                { -0.15, -0.5, -0.15, 0.15, 0.5, 0.15 }
            }
        }
    end


    if (def.glass) then
        sunlight_propagates = true
        drawtype = "glasslike"
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
        groups = { editor = 1 },
        drawtype = drawtype,
        node_box = node_box,
        sunlight_propagates = sunlight_propagates,
    })
end