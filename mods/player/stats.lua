
-- hierarchy = local table of players - player - status value
local stats = {}

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
end)