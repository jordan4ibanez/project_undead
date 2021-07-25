local get_player_by_name = minetest.get_player_by_name

-- hierarchy = local table of players - player - status value
local stats = {}

--[[
health - how healthy you are
hunger - how hungry you are
thirst - how thirsty you are
exhaustion - can limit your speed/stamina
panic - how panicked you are, can cause you to miss swings and not be able to sleep
infection - once bit, this will start climbing
sadness - can cause a bunch of issues
strength - how much you can carry, how hard you can swing
fitness - how fast you can run and for how long
]]--

minetest.register_on_joinplayer(function(player)
    stats[player:get_player_name()] = {
        health = 100,
        hunger = 0,
        thirst = 0,
        exhaustion = 0,
        panic = 0,
        infection = 0,
        sadness = 0,
        strength = 50,
        fitness = 25,
    }

    run_initial_hud_creation(player)
end)

function get_player_stat(player_name, field)
    if (stats[player_name] == nil) then
        return nil
    end

    return(stats[player_name][field])
end

function get_player_stat_table(player_name)
    if (stats[player_name] == nil) then
        return nil
    end

    return(stats[player_name])
end

function set_player_stat(player_name, field, new_value)
    if (stats[player_name] == nil) then
        return
    end

    stats[player_name][field] = new_value

    update_hud(get_player_by_name(player_name), field, new_value)
end

minetest.register_on_leaveplayer(function(player)
    print("needs to save the player's data!")
end)


minetest.register_globalstep(function(dtime)
    local x = get_player_stat("singleplayer", "health")

    print(x)

    if (x == nil) then
        return
    end

    x = x + 1

    if (x < 100) then
        set_player_stat("singleplayer", "health", x)

    elseif (x >= 100) then
        x = 0
        set_player_stat("singleplayer", "health", x)
    end


end)