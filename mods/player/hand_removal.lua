--this automatically clears the green muffin from the players wield hand, swaps to invisible item
minetest.register_on_joinplayer(function(player)
    player:get_inventory():set_stack("hand",1,ItemStack("invisible_hand"))
end)