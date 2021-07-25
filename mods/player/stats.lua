local get_player_by_name = minetest.get_player_by_name

local name
local hp
local generic_stat

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
        hunger = 100, --hunger and thirst work on inverse properties
        thirst = 100, --the lower these drop, the higher your needs
        exhaustion = 0,
        panic = 0,
        infection = 0,
        sadness = 0,
        strength = 50,
        fitness = 25,
    }

    run_initial_hud_creation(player)
end)

function get_player_stat(player_name, stat)
    if (stats[player_name] == nil) then
        return nil
    end

    return(stats[player_name][stat])
end

function get_player_stat_table(player_name)
    if (stats[player_name] == nil) then
        return nil
    end

    return(stats[player_name])
end

function set_player_stat(player_name, stat, new_value)
    if (stats[player_name] == nil) then
        return
    end
    stats[player_name][stat] = new_value
    update_hud(get_player_by_name(player_name), stat, new_value)
end
-- health has it's own functions because it will use them in more specific manors in the future
function digest_hurt(player, damage)
    if (player == nil) then
        return
    end
    name = player:get_player_name()
    if (stats[name] == nil) then
        return
    end
    hp = get_player_stat(name, "health")
    if (hp > 0 and hp - damage > 0) then
        set_player_stat(name, "health", hp - damage)
    elseif (hp > 0 and hp - damage <= 0) then
        --do death
        print("You are dead")
    end
end
function digest_heal(player, regen)
    if (player == nil) then
        return
    end
    name = player:get_player_name()
    if (stats[name] == nil) then
        return
    end
    hp = get_player_stat(name, "health")
    if (hp > 0) then
        hp = hp + regen
        if (hp > 100) then
            hp = 100
        end
        set_player_stat(name, "health", hp)
    end
end

-- generic adder
function digest_stat_addition(player, stat, value)
    if (player == nil) then
        return
    end
    name = player:get_player_name()
    if (stats[name] == nil) then
        return
    end
    generic_stat = get_player_stat(name, stat)
    generic_stat = generic_stat + value
    if (generic_stat > 100) then
        generic_stat = 100
    end
    set_player_stat(name, stat, value)
end

-- generic subtractor
function digest_stat_subtraction(player, stat, value)
    if (player == nil) then
        return
    end
    name = player:get_player_name()
    if (stats[name] == nil) then
        return
    end
    generic_stat = get_player_stat(name, stat)
    generic_stat = generic_stat - value
    if (generic_stat < 0) then
        generic_stat = 0
    end
    set_player_stat(name, stat, value)
end

minetest.register_on_leaveplayer(function(player)
    print("needs to save the player's data!")
end)