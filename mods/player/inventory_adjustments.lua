
if (not editor_mode) then
    minetest.register_on_joinplayer(function(player)
        player:get_inventory():set_size("main", 1)
        player:hud_set_hotbar_itemcount(1)
    end)
else
    minetest.register_on_joinplayer(function(player)
        player:get_inventory():set_size("main", 30)
        player:hud_set_hotbar_itemcount(30)
    end)
end