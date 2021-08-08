minetest.register_on_joinplayer(function(player)
    player:get_inventory():set_size("main", 1)
    player:hud_set_hotbar_itemcount(1)
end)