editor_mode = (minetest.settings:get("editor_mode") == "true")

local path = minetest.get_modpath("terrain").."/"

dofile(path.."tile_builder.lua")
dofile(path.."3d_tile_registration.lua")
dofile(path.."road_registration.lua")
dofile(path.."blank_map_builder.lua")
dofile(path.."spawning.lua")