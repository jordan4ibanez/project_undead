local get_connected_players = minetest.get_connected_players
local register_globalstep = minetest.register_globalstep
local vector_multiply = vector.multiply

local backpack_events = {}
local players_backpacks = {}


local function get_if_player_reaching_for_backpack(player)
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
        return(true)
    end

    return(false)
end


register_globalstep(function(dtime)
    for _,player in pairs(get_connected_players()) do

        local name = player:get_player_name()

        local event = backpack_events[name]

        -- check to see if player is trying to get to their backpack
        if (not event) then
            if (get_if_player_reaching_for_backpack(player) and players_backpacks[name]) then
                print("player is trying to reach for backpack")
                backpack_events[name] = {stage = 1, timer = 0}
                -- player is locked in place until they're holding their backpack
                player:set_physics_override({speed = 0})
                local velocity = player:get_velocity()
                player:add_velocity(vector_multiply(velocity, -1))
            end
        -- player is in backpack animation event
        else
            event.timer = event.timer + dtime

            -- grabbing for backpack
            if (event.stage == 1 and event.timer >= 0.8) then
                -- timer is reached, attach backpack, next stage
                attach_player_backpack_to_hand(player)
                event.stage = 2
                event.timer = 0
                -- bringing backpack over head, and positioning arms
            elseif (event.stage == 2 and event.timer >= 0.8) then
                -- timer is reached, open backpack
                set_player_backpack_opened(player, true)
                event.stage = 3
                event.timer = 0
                -- player can now move around
                player:set_physics_override({speed = 1})
                -- holding backpack in front of player
            elseif (event.stage == 3) then
                -- poll Q (drop) for dropping a backpack on the ground

                -- player wants to put backpack away
                if (get_if_player_reaching_for_backpack(player)) then
                    event.stage = 4
                    event.timer = 0
                    -- close backpack
                    set_player_backpack_opened(player, false)
                    -- player is locked in place until they're done putting away their backpack
                    player:set_physics_override({speed = 0})
                    local velocity = player:get_velocity()
                    player:add_velocity(vector_multiply(velocity, -1))
                end
            elseif (event.stage == 4 and event.timer >= 0.8) then
                -- player's backpack is now back onto their back
                reattach_player_backpack_to_back(player)
                event.stage = 5
                event.timer = 0
            elseif (event.stage == 5 and event.timer >= 0.8) then
                -- animation complete, unlock player
                player:set_physics_override({speed = 1})
                backpack_events[name] = nil
            end
        end
    end
end)

function get_player_backpack_event(player_name)
    return backpack_events[player_name] and backpack_events[player_name].stage
end

function player_has_backpack_open(player)
    local name = player:get_player_name()
    return backpack_events[name] ~= nil
end

minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()

    -- this is a debug and needs to be loaded from a mod save file
    if (not players_backpacks[name]) then
        players_backpacks[name] = {
            slot_1 = "",
            slot_2 = "",
            slot_3 = "",
            slot_4 = "",
            slot_5 = "",
            slot_6 = "",
            slot_7 = "",
            slot_8 = "",
            slot_9 = "",
            slot_10 = ""
        }

        minetest.after(0, function()
            set_player_backpack_visibility(player, true)
        end)
    end
end)