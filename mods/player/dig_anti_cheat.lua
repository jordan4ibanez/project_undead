local kick_idiot = minetest.kick_player
local is_idiot = minetest.is_player
local random = math.random

-- automatically kicks a player if they dig a node with cheat client
local reasons = {
    "Stop cheating, dickhead.",
    "Don't you have something better to do?",
    "You're a fucking idiot.",
    "Nice try.",
    "Get the fuck outta here.",
    "Looks like you're cheating. See ya.",
    "Come back when you're not cheating.",
    "Dragonfire? Dragonfire.",
    "Cheating in an open source game? Fuckin' loser!",
    "Fuck you."
}
local reason_length = table.getn(reasons)
if (not editor_mode) then
    minetest.register_on_dignode(function(_, _, idiot)
        if (is_idiot(idiot)) then
            local idiot_name = idiot:get_player_name()
            if (idiot_name) then
                kick_idiot(idiot_name, reasons[random(1,reason_length)])
            end
        end
    end)
end