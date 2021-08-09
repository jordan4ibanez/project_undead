local register_craftitem = minetest.register_craftitem
local vector_add = vector.add
local vector_multiply = vector.multiply
local raycast = minetest.raycast

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

    if (def.hunger) then
        groups.hunger = def.hunger
    end

    if (def.thirst) then
        groups.thirst = def.thirst
    end

    local do_take = not editor_mode

    local on_place = function(itemstack, player)
        local pos1 = vector_add(player:get_pos(), { x = 0, y = player:get_properties().eye_height, z = 0})
        local pos2 = vector_add(pos1, vector_multiply(player:get_look_dir(), 20))
        local points = raycast(pos1, pos2, false, false)


        if (points) then
            local pos = points:next()
            if (pos) then
                pos = pos.intersection_point
                add_item(pos, itemstack:get_name(), player:get_look_horizontal())
                if (do_take) then
                    itemstack:take_item(1)
                    return(itemstack)
                end
            end
        end
    end

    register_craftitem(":"..def.name,{
        description = def.description,
        groups = groups,
        inventory_image = def.texture,
        wield_image = def.texture,
        wield_overlay = "invisible.png",
        on_place = on_place
    })
end