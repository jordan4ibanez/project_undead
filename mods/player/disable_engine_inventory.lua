local register_globalstep = minetest.register_globalstep
local get_connected_players = minetest.get_connected_players
local close_formspec = minetest.close_formspec

--[[
this is a combination of https://forum.minetest.net/viewtopic.php?t=24572 and rubenwardy's recommendation

this is an extreme hack, which disables the internal inventory system from being accessible

in cases of lag, players can still unlock their mouse, this is unacceptable
]]--

if (not editor_mode) then
    minetest.register_on_joinplayer(function(player)
        player:set_inventory_formspec("size[0,0]position[-100,-100]")
    end)
    register_globalstep(function()
        for _, player in pairs(get_connected_players()) do
            close_formspec(player:get_player_name(), "")
        end
    end)
end