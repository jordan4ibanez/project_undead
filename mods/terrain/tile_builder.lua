local register_node = minetest.register_node

--this is a wrapper for the build in Minetest library, can be used to optimize nodes, now called tiles since game is mostly 2D in nature
function register_tile(def)
    local param2
    local drawtype
    local tiles
    local node_box
    local sunlight_propagates
    local use_texture_alpha

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

    -- an easier way to define glass
    if (def.glass) then
        sunlight_propagates = true
        drawtype = "glasslike"
    end

    -- a much easier way to get pixel perfect node boxes
    if (def.pixel_box) then
        sunlight_propagates = def.translucent or true

        -- throws an error for undefined texture size
        if (not def.pixel_box_texture_size) then
            error("You must define the pixel_box_texture_size in tile: " .. def.name)
        end


        -- automatically format pixel integer to floating point precision
        for parent_id,parent_table in pairs(def.pixel_box) do
            for child_id,child_value in pairs(parent_table) do
                def.pixel_box[parent_id][child_id] = (child_value / def.pixel_box_texture_size) - 0.5
            end
        end

        node_box = {
            type = "fixed",
            fixed = def.pixel_box
        }

        drawtype = "nodebox"

        use_texture_alpha = "clip"
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
        use_texture_alpha = use_texture_alpha,
    })
end