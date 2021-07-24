--basically turn everything off
minetest.register_on_joinplayer(function(player)
    player:hud_set_flags({crosshair = false, wielditem = false, hotbar = false, healthbar = false, breathbar = false, minimap = true, minimap_radar = false})
end)