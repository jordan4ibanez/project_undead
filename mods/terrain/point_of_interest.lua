local get_timeofday = minetest.get_timeofday
local random = math.random

-- cached data
local timer = 0
local current_time = 0

local function roll_dice()
    return(random() * 100)
end


-- this is a table which defines where zombies/hordes spawn

--[[
pos - base position of point of interest
hordes - allow 30-50 zombies to spawn at once
horde_chance - how often zombies will normally spawn in a horde (0-100%), higher is higher chance
amount_normal = amount that will normally spawn during spawn hours (night time)
chance - how often zombies will normally spawn (0-100%), higher is higher chance
radius - how far away zombies can spawn, zombies will only spawn on road surfaces or inside buildings

time_begin - the earliest zombies can start spawning, must be less than midnight, as in 7:00pm (19:00) for example
time_end - the latest time zombies stop spawning, must be after midnight, as in 5:00am (05:00) for example
spawn_frequency - how often, in seconds, the map will try to spawn zombies/hordes at points of interest

a note:
time comparison is quite easy and simple
1.) take your time, we'll use 3:00pm for example
2.) if time is pm, which is after noon, literally, you must add 12 to the former number which in this case is 3.
3.) In this example, this will give us the number 15:00
4.) Now remove the colon off off the number, and add a zero.
5.) The time is now 15000 and can be used in the time_begin and time_end variables accordingly

]]--


local time_begin = 20000
local time_end = 4800
local spawn_frequency = 1


local interest_table = {
    -- east highway gas station
    {pos = { x = 700, z = 11}, hordes = true, horde_chance = 50, amount_normal = 10, chance = 80, radius = 40}
}


minetest.register_globalstep(function(dtime)

    timer = timer + dtime
    -- only initialize every spawn_frequency seconds
    if (timer >= spawn_frequency) then
        -- this must be multiplied to get a relatable time scale
        current_time = get_timeofday() * 24000
        -- only spawn between acceptable times
        if (current_time > time_begin or current_time < time_end) then
            -- run through each point of interest
            for _,point in pairs(interest_table) do
                -- roll the virtual dice to see if this will spawn more zombies
                if (roll_dice() < point.chance) then
                    -- now roll the dice and see if a horde will spawn
                    if (roll_dice() < point.horde_chance) then
                        -- someone's about to have a bad day
                        
                    else
                        -- spawn zombies in amount_normal amount


                    end
                end
            end
        end
    end
end)

