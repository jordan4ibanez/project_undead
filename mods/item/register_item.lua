local register_craftitem = minetest.register_craftitem

--this is a wrapper for minetest.register_craftitem, this is implemented because it makes custom mechanics easier to implement
function register_item(def)

    local groups = {}

    if (def.gun) then
        groups.gun = 1
    end


    register_craftitem(":"..def.name,{
        description = def.description,
        groups = groups,
        inventory_image = def.texture,
        wield_image = "invisible.png",
        wield_overlay = "invisible.png",
    })
end