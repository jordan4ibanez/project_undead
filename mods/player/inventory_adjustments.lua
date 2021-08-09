local create_detached_inventory = minetest.create_detached_inventory

if (not editor_mode) then
    minetest.register_on_joinplayer(function(player)
        player:get_inventory():set_size("main", 1)
        player:hud_set_hotbar_itemcount(1)
    end)
else
    minetest.register_on_joinplayer(function(player)
        player:get_inventory():set_size("main", 30)
        player:hud_set_hotbar_itemcount(30)

        local name = player:get_player_name()
        
        -- creates the off hand (left hand) inventory
        create_detached_inventory("secondary", nil, name)
        player:get_inventory():set_size("secondary", 1)
    end)
end