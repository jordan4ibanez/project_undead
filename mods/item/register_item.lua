local register_craftitem = minetest.register_craftitem

--this is a wrapper for minetest.register_craftitem, this is implemented because it makes custom mechanics easier to implement
function register_item(def)

    local groups = {}

    if (def.gun) then
        groups.gun = 1
    end

    if (def.scale) then
        groups.scale_x = def.scale[1] * 0.2
        groups.scale_y = def.scale[2] * 0.2
        groups.scale_z = def.scale[3] * 0.2
    else
        groups.scale_x = 0.2
        groups.scale_y = 0.2
        groups.scale_z = 0.2
    end

    local on_place = nil
    
    if (editor_mode) then
        on_place = function(itemstack, placer, pointed_thing)
            print(dump(pointed_thing))
        end
    end

    register_craftitem(":"..def.name,{
        description = def.description,
        groups = groups,
        inventory_image = def.texture,
        wield_image = def.texture,
        wield_overlay = "invisible.png",
    })
end