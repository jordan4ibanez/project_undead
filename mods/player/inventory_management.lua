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

                    local stack_1 = inventory:get_stack("main", 1)
                    local stack_2 = inventory:get_stack("secondary", 1)

                    inventory:set_stack("main", 1, stack_2)
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
    end
end)

function set_player_item_swap_cooldown(player, time)
    local name = player:get_player_name()
    cool_down[name] = time
end

allocate_drop_button(
        function(itemstack,player,pos)
            if (not player_has_backpack_open(player)) then
                local inventory = player:get_inventory()
                local stack = inventory:get_stack("main", 1)
                local name = stack:get_name()
                if (name ~= "") then
                    local pos = player:get_pos()
                    local yaw = player:get_look_horizontal()
                    add_item(pos, name, yaw)
                    stack:take_item(1)
                    inventory:set_stack("main", 1, stack)
                end
            end
        end
)
