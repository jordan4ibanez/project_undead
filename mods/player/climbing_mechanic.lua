local register_globalstep = minetest.register_globalstep
local get_connected_players = minetest.get_connected_players
local dir_to_facedir = minetest.dir_to_facedir
local facedir_to_dir = minetest.facedir_to_dir
local get_item_group = minetest.get_item_group
local yaw_to_dir = minetest.yaw_to_dir
local get_node = minetest.get_node
local facedir_to_dir = minetest.facedir_to_dir
local dir_to_yaw = minetest.dir_to_yaw
local vector_add = vector.add
local vector_direction = vector.direction
local vector_floor = vector.floor
local vector_distance = vector.distance
local vector_multiply = vector.multiply
local new_vector = vector.new

local climb_event = {}

local function digest_direction(dir)
    return facedir_to_dir(dir_to_facedir(dir))
end

local function floor(pos)
    return vector_floor(vector_add(pos, 0.5))
end

function player_climbing_over(player_name)
    local event = climb_event[player_name]
    return event ~= nil and event.type == "climb_over"
end

function player_climbing_ladder(player_name)
    local event = climb_event[player_name]
    return event ~= nil and (event.type == "up_ladder" or event.type == "down_ladder")
end

function player_on_ladder(player_name)
    local event = climb_event[player_name]
    return event ~= nil and event.type == "on_ladder"
end

function player_climbing_off_ladder(player_name)
    local event = climb_event[player_name]
    return event ~= nil and event.type == "climb_off_ladder"
end

function player_climbing_onto_ladder_from_top(player_name)
    local event = climb_event[player_name]
    return event ~= nil and event.type == "onto_ladder_from_top"
end

local function get_ladder_climbing_controls(player)
    local control_bits = player:get_player_control_bits()

    local return_bit = 0

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
        return_bit = return_bit - 1
    end

    -- aux1
    if (control_bits >= 32) then
        control_bits = control_bits - 32
    end

    -- jump
    if (control_bits >= 16) then
        control_bits = control_bits - 16
        return_bit = return_bit + 1
    end

    return(return_bit)
end

register_globalstep(function(dtime)
    for _,player in pairs(get_connected_players()) do

        local name = player:get_player_name()

        -- run through climb event
        if (climb_event[name]) then

            local player_pos = player:get_pos()

            local event = climb_event[name]

            if (event.type == "climb_over") then

                event.timer = event.timer + dtime

                --stop player from moving around
                --local velocity = player:get_velocity()
                --player:add_velocity({ x = -velocity.x / 2, y = -velocity.y / 2, z = -velocity.z / 2})

                -- do animation
                if (vector_distance(player_pos, event.end_pos) > 0.15 and event.timer < 1) then
                    local direction = vector_direction(player_pos, event.end_pos)
                    direction = vector_multiply(direction, dtime * 2)
                    player:set_pos(vector_add(player_pos,direction))
                    -- return to normal
                else
                    player:set_pos(event.end_pos)
                    player:set_physics_override({speed = 1})
                    climb_event[name] = nil
                end
            elseif (event.type == "up_ladder" or event.type == "down_ladder") then

                player:set_look_horizontal(event.yaw)

                --stop player from moving around
                --local velocity = player:get_velocity()
                --player:add_velocity({ x = -velocity.x / 2, y = -velocity.y / 2, z = -velocity.z / 2})

                event.timer = event.timer + dtime

                -- do animation
                if (vector_distance(player_pos, event.end_pos) > 0.15 and event.timer < 1) then

                    local direction = vector_direction(player_pos, event.end_pos)

                    direction = vector_multiply(direction, dtime * 2)

                    player:set_pos(vector_add(player_pos,direction))
                    -- return to normal
                else
                    player:set_pos(event.end_pos)
                    event.timer = 0
                    event.type = "on_ladder"
                end
            elseif (event.type == "onto_ladder_from_top") then
                player:set_look_horizontal(event.yaw)

                --stop player from moving around
                --local velocity = player:get_velocity()
                --player:add_velocity({ x = -velocity.x / 2, y = -velocity.y / 2, z = -velocity.z / 2})

                event.timer = event.timer + dtime

                -- do animation
                if (vector_distance(player_pos, event.end_pos) > 0.15 and event.timer < 1) then

                    local direction = vector_direction(player_pos, event.end_pos)

                    direction = vector_multiply(direction, dtime * 2)

                    player:set_pos(vector_add(player_pos,direction))
                    -- return to normal
                else
                    player:set_pos(event.end_pos)
                    event.timer = 0
                    event.type = "on_ladder"
                end

            elseif (event.type == "on_ladder") then

                player:set_look_horizontal(event.yaw)

                --stop player from moving around
                player:set_pos(event.end_pos)
                --local velocity = player:get_velocity()
                --player:add_velocity({ x = -velocity.x / 2, y = -velocity.y / 2, z = -velocity.z / 2})

                local ladder_control_bit = get_ladder_climbing_controls(player)

                -- if a player is pressing space
                if (ladder_control_bit == 1) then

                    local tile = get_node({x = event.end_pos.x, y = event.end_pos.y + 1, z = event.end_pos.z}).name
                    local tile_above = get_node({x = event.end_pos.x, y = event.end_pos.y + 2, z = event.end_pos.z}).name

                    local tile_group = get_item_group(tile, "ladder") > 0
                    local tile_above_group = get_item_group(tile_above, "ladder") > 0

                    -- continue climbing the ladder
                    if (tile_group and tile_above_group) then
                        event.end_pos.y = event.end_pos.y + 1
                        event.type = "up_ladder"
                    -- get player off the ladder - climbing off event
                    elseif (tile_group and not tile_above_group) then
                        -- check if non-air in front of ladder
                        local in_front_pos = vector_add(event.end_pos, event.dir)

                        -- relocate it to where the player's model's hands are
                        in_front_pos.y = in_front_pos.y + 1

                        if (get_node(in_front_pos).name ~= "air") then
                            -- check if space on top of non-air tile
                            in_front_pos.y = in_front_pos.y + 1
                            if (get_node(in_front_pos).name == "air") then
                                -- check if enough room for player
                                in_front_pos.y = in_front_pos.y + 1
                                if (get_node(in_front_pos).name == "air") then
                                    -- initialize climbing off event
                                    in_front_pos.y = in_front_pos.y - 1
                                    event.end_pos = in_front_pos
                                    event.type = "climb_off_ladder"
                                    event.timer = 0
                                end
                            end
                        end
                    end
                -- if a player is pressing shift
                elseif (ladder_control_bit == -1) then

                    local tile = get_node({x = event.end_pos.x, y = event.end_pos.y - 1, z = event.end_pos.z}).name
                    -- check if getting off ladder
                    if (get_item_group(tile, "ladder") > 0) then
                        event.end_pos.y = event.end_pos.y - 1
                        event.type = "down_ladder"
                    -- get off the ladder - don't allow players to fall
                    elseif (tile ~= "air") then
                        player:set_physics_override({speed = 1,gravity = 10})
                        climb_event[name] = nil
                    end

                end
            elseif (event.type == "climb_off_ladder") then

                --stop player from moving around
                --local velocity = player:get_velocity()
                --player:add_velocity({ x = -velocity.x / 2, y = -velocity.y / 2, z = -velocity.z / 2})

                player:set_look_horizontal(event.yaw)

                event.timer = event.timer + dtime

                -- do animation
                if (vector_distance(player_pos, event.end_pos) > 0.15 and event.timer < 1) then

                    local direction = vector_direction(player_pos, event.end_pos)

                    direction = vector_multiply(direction, dtime * 2)

                    player:set_pos(vector_add(player_pos,direction))
                -- return to normal
                else
                    player:set_pos(event.end_pos)
                    player:set_physics_override({speed = 1,gravity = 10})
                    climb_event[name] = nil
                end
            end

        -- do climb scanning
        else
            -- a cache happy way to intercept player controls
            local initialize_climb = false
            local moving_forward = false
            local cancel_movement = false
            local climb_down = false

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
                climb_down = true
            end

            -- aux1
            if (control_bits >= 32) then
                control_bits = control_bits - 32
            end

            -- jump
            if (control_bits >= 16) then
                control_bits = control_bits - 16
                initialize_climb = true
            end

            -- poll to see if player is set up to climb on or over something
            if (initialize_climb) then
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

                    -- must add 0.05 to help collision detection issues
                    real_pos.y = real_pos.y + 0.05

                    local pos = floor(real_pos)
                    local yaw = player:get_look_horizontal()
                    local dir = digest_direction(yaw_to_dir(yaw))

                    -- move the base position to the tile trying to climb over - assumption
                    local tile_pos = vector_add(pos, dir)

                    local climb_over_able = false
                    local inside = false

                    local tile_inside_name = get_node(pos).name
                    local tile_front_name = get_node(tile_pos).name

                    -- allow for being inside the tile
                    if (get_item_group(tile_inside_name, "climb_over") > 0) then
                        climb_over_able = true
                        inside = true
                    elseif (get_item_group(tile_front_name, "climb_over") > 0) then
                        climb_over_able = true
                    end

                    -- climb over
                    -- begin check to see if viable to climb over at all
                    if (climb_over_able) then

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
                            climb_event[name] = {type = "climb_over", end_pos = finalized_pos, timer = 0}
                            player:set_physics_override({speed = 0})
                        end
                    -- ladder climb
                    elseif (player:get_velocity().y == 0) then
                        -- check if trying to climb up ladder - inside tile
                        if (get_item_group(tile_inside_name, "ladder") > 0) then
                            --make sure there are at least 2 ladder segments
                            if (get_item_group(get_node(vector_add(pos, { x = 0, y = 1, z = 0})).name, "ladder") > 0) then
                                local finalized_pos = pos
                                local ladder_dir = facedir_to_dir(get_node(pos).param2)
                                climb_event[name] = {type = "up_ladder", end_pos = finalized_pos, timer = 0, yaw = dir_to_yaw(ladder_dir), dir = ladder_dir}
                                player:set_physics_override({speed = 0, gravity = 0})
                            end
                        end
                    end
                end
            -- check if trying to climb down ladder
            elseif (climb_down) then

                -- avoid corner glitches
                local real_pos = player:get_pos()

                -- must add 0.05 to help collision detection issues
                real_pos.y = real_pos.y + 0.05

                local pos = floor(real_pos)
                local yaw = player:get_look_horizontal()
                local dir = digest_direction(yaw_to_dir(yaw))

                pos = vector_add(pos,dir)

                -- don't let players glitch diagonally through built structures
                -- must have air above the ladder
                if (get_node(pos).name == "air") then
                    pos.y = pos.y - 1
                    --initialize climbing down ladder
                    if (get_item_group(get_node(pos).name, "ladder") > 0) then
                        --make sure there are at least 2 ladder segments
                        pos.y = pos.y - 1
                        if (get_item_group(get_node(pos).name, "ladder") > 0) then
                            local finalized_pos = pos
                            local ladder_dir = facedir_to_dir(get_node(pos).param2)
                            climb_event[name] = {type = "onto_ladder_from_top", end_pos = finalized_pos, timer = 0, yaw = dir_to_yaw(ladder_dir), dir = ladder_dir}
                            player:set_physics_override({speed = 0, gravity = 0})
                        end
                    end
                end
            end
        end
    end
end)