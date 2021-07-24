local register_craftitem = minetest.register_craftitem

--this is a wrapper for minetest.register_craftitem, this is implemented because it makes custom mechanics easier to implement
function register_item(def)
    register_craftitem(":"..def.name,{
        description = def.description,
        groups = def.groups or {},
        inventory_image = def.inventory_image,
        wield_image = "invisible.png",
        wield_overlay = "invisible.png",
    })
end