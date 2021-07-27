-- this is a table which defines where zombies/hordes spawn

--[[
pos - base position of point of interest
hordes - allow 30-50 zombies to spawn at once
amount_normal = amount that will normally spawn during spawn hours (night time)
chance - every time the server "ticks" to spawning, it will do a random number and compare this to it (0-100), the higher the chance, the higher the possibility zombies will spawn
radius - how far away zombies can spawn, zombies will only spawn on road surfaces or inside buildings
]]--

local interest_table = {
    --east highway gas station
    {pos = { x = 700, z = 11}, hordes = true, amount_normal = 10, chance = 80, radius = 40}
}