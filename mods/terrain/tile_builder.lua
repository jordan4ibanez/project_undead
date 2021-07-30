local register_node = minetest.register_node

--this is a wrapper for the build in Minetest library, can be used to optimize nodes, now called tiles since game is mostly 2D in nature
function register_tile(def)
    local paramtype
    local param2
    local drawtype
    local tiles
    local node_box
    local sunlight_propagates
    local use_texture_alpha
    local connects_to
    local groups = {}

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
        paramtype = "light"
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
        paramtype = "light"
    end

    -- a much easier way to get pixel perfect node boxes
    if (def.pixel_box) then

        -- throws an error for undefined texture size
        if (not def.pixel_box_texture_size) then
            error("You must define the pixel_box_texture_size in tile: " .. def.name)
        end


        -- automatically format pixel integer to floating point precision
        for parent_id,parent_table in pairs(def.pixel_box) do
            for child_id,child_value in pairs(parent_table) do
                def.pixel_box[parent_id][child_id] = (-child_value / def.pixel_box_texture_size) + 0.5
            end
        end

        node_box = {
            type = "fixed",
            fixed = def.pixel_box
        }

        drawtype = "nodebox"

        use_texture_alpha = "clip"

        param2 = "facedir"

        sunlight_propagates = def.translucent or true

        if (sunlight_propagates) then
            paramtype = "light"
        end
    end

    if (def.pixel_box_specific) then
        node_box = def.pixel_box_specific

        drawtype = "nodebox"

        use_texture_alpha = "clip"

        sunlight_propagates = def.translucent or true

        if (sunlight_propagates) then
            paramtype = "light"
        end

        connects_to = def.connects_to
    end

    -- creates fences automatically
    if (def.fence) then

        local fixed

        if (editor_mode) then
            fixed = {
                { -0.15, -0.5, -0.15, 0.15, 0.5, 0.15 }
            }
        end

        node_box = {
            type = "connected",
            fixed = fixed,
            connect_front = {
                { 0, -0.5, -0.5, 0, 0.5, 0 }
            },

            connect_back = {
                { 0, -0.5, 0, 0, 0.5, 0.5 }
            },

            connect_left = {
                { -0.5, -0.5, 0, 0, 0.5, 0 }
            },

            connect_right = {
                { 0, -0.5, 0, 0.5, 0.5, 0 }
            }

        }

        drawtype = "nodebox"

        use_texture_alpha = "clip"

        connects_to = def.fence_connections

        sunlight_propagates = def.translucent or true

        paramtype = "light"

        if (sunlight_propagates) then
            paramtype = "light"
        end

    end

    if (def.road) then
        groups.road = 1
    end

    if (editor_mode) then
        groups.editor = 1
    end

    if (def.climb_over) then
        groups.climb_over = 1
    end


    -- disable fall damage
    groups.fall_damage_add_percent = -100

    -- disable jumping
    groups.disable_jump = 1
    
    register_node(":" .. (def.name or "you've failed to name your tile"), {
        description = def.description,
        tiles = tiles,
        paramtype = paramtype,
        paramtype2 = param2,
        pointable = def.pointable or (editor_mode or false),
        diggable = editor_mode or false,
        is_ground_content = false,
        buildable_to = false,
        floodable = false,
        liquidtype = nil,
        damage_per_second = def.dps or nil,
        waving = def.waving,
        groups = groups,
        drawtype = drawtype,
        node_box = node_box,
        sunlight_propagates = sunlight_propagates,
        use_texture_alpha = use_texture_alpha,
        connects_to = connects_to,
    })
end