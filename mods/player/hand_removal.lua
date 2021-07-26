if (build_mode) then
    minetest.override_item("", {
        range = 100,
        tool_capabilities = {
            groupcaps = {
                editor = {times = { [1] = 50}, uses = 1000000, maxlevel = 256},
            }
        }
    })
end

--this automatically clears the green muffin from the players wield hand, swaps to invisible item
minetest.register_on_joinplayer(function(player)
    player:get_inventory():set_stack("hand",1,ItemStack("invisible_hand"))
end)