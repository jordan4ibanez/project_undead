local get_timeofday = minetest.get_timeofday

local timer = 0
local current_time = 0


-- this is a table which defines where zombies/hordes spawn

--[[
pos - base position of point of interest
hordes - allow 30-50 zombies to spawn at once
amount_normal = amount that will normally spawn during spawn hours (night time)
chance - every time the server "ticks" to spawning, it will do a random number and compare this to it (0-100), the higher the chance, the higher the possibility zombies will spawn
radius - how far away zombies can spawn, zombies will only spawn on road surfaces or inside buildings

time_begin - the earliest zombies can start spawning, must be less than midnight, as in 7:00pm (19:00) for example
time_end - the latest time zombies stop spawning, must be after midnight, as in 5:00am (05:00) for example

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


local interest_table = {
    --east highway gas station
    {pos = { x = 700, z = 11}, hordes = true, amount_normal = 10, chance = 80, radius = 40}
}



minetest.register_globalstep(function(dtime)
    --this must be multiplied to get a relatable time scale

    current_time = get_timeofday() * 24000

    if (current_time > time_begin or current_time < time_end) then
        print("it's spawning time!")
    end

end)