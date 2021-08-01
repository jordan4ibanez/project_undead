local register_globalstep = minetest.register_globalstep
local get_connected_players = minetest.get_connected_players
local dir_to_facedir = minetest.dir_to_facedir
local facedir_to_dir = minetest.facedir_to_dir
local get_item_group = minetest.get_item_group
local yaw_to_dir = minetest.yaw_to_dir
local get_node = minetest.get_node
local vector_add = vector.add
local vector_direction = vector.direction
local vector_floor = vector.floor
local vector_distance = vector.distance
local vector_multiply = vector.multiply
local new_vector = vector.new

local climb_over_events = {}

local function digest_direction(dir)
    return facedir_to_dir(dir_to_facedir(dir))
end

local function floor(pos)
    return vector_floor(vector_add(pos, 0.5))
end

function player_in_climb_over_animation(player_name)
    return climb_over_events[player_name] ~= nil
end

register_globalstep(function(dtime)
    for _,player in pairs(get_connected_players()) do

        local name = player:get_player_name()

        -- run through climb over event
        if (climb_over_events[name]) then

            local player_pos = player:get_pos()

            local event = climb_over_events[name]

            event.timer = event.timer + dtime

            -- do animation
            if (vector_distance(player_pos, event.end_pos) > 0.15 and event.timer < 1) then
                local direction = vector_direction(player_pos, event.end_pos)
                direction = vector_multiply(direction, dtime * 2)
                player:set_pos(vector_add(player_pos,direction))
            -- return to normal
            else
                player:set_pos(event.end_pos)
                player:set_physics_override({speed = 1})
                climb_over_events[name] = nil
            end

        -- do climb over scanning
        else

            -- a cache happy way to intercept player controls
            local initialize_climb_over = false
            local moving_forward = false
            local cancel_movement = false

            local control_bits = player:get_player_control_bits()

            -- zoom
            if (control_bits >= 512) then
                control_bits = control_bits - 512
            end

            -- place
            if (control_bits >= 256) then
                control_bits = control_bits - 256
            end

            -- dig
            if (control_bits >= 128) then
                control_bits = control_bits - 128
            end

            -- sneak
            if (control_bits >= 64) then
                control_bits = control_bits - 64
            end

            -- aux1
            if (control_bits >= 32) then
                control_bits = control_bits - 32
            end

            -- jump
            if (control_bits >= 16) then
                control_bits = control_bits - 16
                initialize_climb_over = true
            end

            -- poll to see if player is set up to climb over something
            if (initialize_climb_over) then
                -- right
                if (control_bits >= 8) then
                    control_bits = control_bits - 8
                    cancel_movement = true
                end

                -- left
                if (control_bits >= 4) then
                    control_bits = control_bits - 4
                    cancel_movement = true
                end

                -- down
                if (control_bits >= 2) then
                    control_bits = control_bits - 2
                    cancel_movement = true
                end

                -- up
                if (control_bits >= 1) then
                    control_bits = control_bits - 1
                    moving_forward = true
                end

                if (not cancel_movement and moving_forward) then
                    -- avoid corner glitches
                    local real_pos = player:get_pos()

                    local pos = floor(real_pos)
                    local yaw = player:get_look_horizontal()
                    local dir = digest_direction(yaw_to_dir(yaw))

                    -- move the base position to the tile trying to climb over - assumption
                    local tile_pos = vector_add(pos, dir)

                    local activated = false
                    local inside = false

                    -- allow for being inside the tile
                    if (get_item_group(get_node(pos).name, "climb_over") > 0) then
                        activated = true
                        inside = true
                    elseif (get_item_group(get_node(tile_pos).name, "climb_over") > 0) then
                        activated = true
                    end

                    -- begin check to see if viable to climb over at all
                    if (activated) then

                        local check_pos

                        -- automatically adjust the position accordingly
                        if (inside) then
                            check_pos = pos
                        else
                            check_pos = tile_pos
                        end

                        -- make sure there is space above and in front of the tile
                        if (get_node(vector_add(check_pos, new_vector(0,1,0))).name == "air" and get_node(vector_add(check_pos, dir)).name == "air") then

                            local finalized_pos = vector_add(check_pos, dir)

                            finalized_pos.y = real_pos.y

                            -- begin climb over animation
                            climb_over_events[name] = {start_pos = real_pos, end_pos = finalized_pos, timer = 0}
                            player:set_physics_override({speed = 0})
                        end
                    end
                end
            end
        end
    end
end)