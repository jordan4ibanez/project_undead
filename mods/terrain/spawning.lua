local get_timeofday = minetest.get_timeofday
local find_nodes_in_area_under_air = minetest.find_nodes_in_area_under_air
local add_entity = minetest.add_entity
local get_connected_players = minetest.get_connected_players
local get_objects_in_area = minetest.get_objects_in_area
local vector_distance = vector.distance
local random = math.random
local getn = table.getn

-- cached data
local timer = 0
local current_time = 0
local found_spawn_locations
local final_spawn_location
local spawn_table_size
local spawn_failure
local zombie_count

local function roll_dice()
    return(random() * 100)
end

local function digest_time()
    -- this must be multiplied to get a relatable time scale
    return(get_timeofday() * 24000)
end

-- this is a table which defines where zombies/hordes spawn

--[[
pos - base position of point of interest
hordes - allow 30-50 zombies to spawn at once
horde_chance - how often zombies will normally spawn in a horde (0-100%), higher is higher chance
amount_normal - amount that will normally spawn during spawn hours (night time)
zombie_limit - how many zombies can be in the spawn area before the spawner stops until the amount goes lower
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
    {pos = { x = 700, y = 0, z = 11}, hordes = true, horde_chance = 50, amount_normal = 10, zombie_limit = 30, chance = 80, radius = 40}
}


local function spawn_zombie(min_pos, max_pos)
    final_spawn_location = nil

    found_spawn_locations = find_nodes_in_area_under_air(min_pos, max_pos, "group:road")

    spawn_table_size = getn(found_spawn_locations)

    if (found_spawn_locations and spawn_table_size > 0) then
        final_spawn_location = found_spawn_locations[random(1, spawn_table_size)]
    end

    if (final_spawn_location) then
        final_spawn_location.y = final_spawn_location.y + 0.5
        add_entity(final_spawn_location, "zombie")
    end
end

minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    -- only initialize every spawn_frequency seconds
    if (timer >= spawn_frequency) then
        timer = 0
        -- only spawn between acceptable times
        current_time = digest_time()
        if (current_time > time_begin or current_time < time_end) then
            -- run through each point of interest
            for _,point in pairs(interest_table) do
                spawn_failure = false

                -- do not attempt a spawn if any player can see it happening
                for _,player in pairs(get_connected_players()) do
                    if (vector_distance(player:get_pos(), point.pos) <= point.radius) then
                        spawn_failure = true
                        break
                    end
                end

                zombie_count = 0
                -- do not attempt a spawn if too many zombies already
                for _,object in pairs(get_objects_in_area(point.min_pos, point.spawner_max_pos)) do
                    if (not object:is_player() and object:get_luaentity().zombie) then
                        zombie_count = zombie_count + 1
                        if (zombie_count > point.zombie_limit) then
                            spawn_failure = true
                            break
                        end
                    end
                end

                -- roll the virtual dice to see if this will spawn more zombies
                if (not spawn_failure and roll_dice() < point.chance) then
                    -- now roll the dice and see if a horde will spawn
                    if (point.hordes and roll_dice() < point.horde_chance) then
                        -- someone's about to have a bad day
                        for _ = 1,random(30,50) do
                            spawn_zombie(point.min_pos, point.max_pos)
                        end
                    else
                        -- spawn zombies in amount_normal amount
                        for _ = 1,random(1,point.amount_normal) do
                            spawn_zombie(point.min_pos, point.max_pos)
                        end
                    end
                end
            end
        end
    end
end)


-- digest positions and add needed data automatically
minetest.register_on_mods_loaded(function()
    for _,point in pairs(interest_table) do
        point.min_pos = { x = point.pos.x - point.radius, y = 0, z = point.pos.z - point.radius}
        point.max_pos = { x = point.pos.x + point.radius, y = 0, z = point.pos.z + point.radius}
        -- this variable allows for ease of use in the spawning algorithm
        point.spawner_max_pos = { x = point.pos.x + point.radius, y = 2, z = point.pos.z + point.radius}
    end
end)