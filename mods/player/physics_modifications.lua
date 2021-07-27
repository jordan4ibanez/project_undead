minetest.register_on_joinplayer(function(player)
    player:set_physics_override({jump=0,sneak = false, gravity = 10})
end)