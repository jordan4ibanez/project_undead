local get_connected_players = minetest.get_connected_players
local register_globalstep = minetest.register_globalstep

local function is_player_swapping(player)
    local control_bits = player:get_player_control_bits()

    -- zoom
    if (control_bits >= 512) then
        return(true)
    end

    return(false)
end

local cool_down = {}


register_globalstep(function(dtime)
    for _,player in pairs(get_connected_players()) do
        if (is_player_swapping(player)) then
            if (not player_has_backpack_open(player)) then
                local name = player:get_player_name()
                if (not cool_down[name]) then
                    -- do the swap
                    local inventory = player:get_inventory()

                    local stack_1 = player:get_wielded_item()
                    local stack_2 = inventory:get_stack("secondary", 1)

                    player:set_wielded_item(stack_2)
                    inventory:set_stack("secondary", 1, stack_1)

                    cool_down[name] = 0.25
                end
            end
        end
    end

    -- lua vm should automatically optimize itself if no cool_down
    for index,time in pairs(cool_down) do
        cool_down[index] = time - dtime

        if (cool_down[index] <= 0) then
            cool_down[index] = nil
        end

        print(cool_down[index])
    end
end)


