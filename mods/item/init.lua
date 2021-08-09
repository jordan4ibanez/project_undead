local path = minetest.get_modpath("item").."/"

dofile(path.."register_item.lua")
dofile(path.."food_registration.lua")
dofile(path.."gun_registration.lua")
dofile(path.."override_built_in_item_entity.lua")