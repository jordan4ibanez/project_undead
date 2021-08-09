local add_entity = minetest.add_entity
local registered_items = minetest.registered_items

minetest.register_entity(":item", {
    initial_properties = {
        hp_max           = 1,
        visual           = "wielditem",
        physical         = false,
        textures         = {""},
        is_visible       = true,
        pointable        = true,
        collide_with_objects = false,
        collisionbox = {0,0,0,0,0,0},
        selectionbox = {-0.21, -0.21, -0.21, 0.21, 0.21, 0.21},
        visual_size  = {x = 1, y = 1, z = 1},
    },

    scale = 0,

    set_item = function(self, item)
        local stack = ItemStack(item or self.itemstring)
        self.itemstring = stack:to_string()
        if self.itemstring == "" then
            self.object:remove()
            return
        end
        local itemname = stack:is_known() and stack:get_name() or "unknown"

        local definition = registered_items[itemname]

        local scale = {x = definition.groups.scale_x, y = definition.groups.scale_y, z = definition.groups.scale_z}

        self.scale = scale.y

        self.object:set_properties({
            collisionbox = {0,0,0,0,0,0},
            selectionbox = {-scale.x, 0, -scale.z, scale.x, scale.y * 2, scale.z},
            visual_size = scale,
            textures = {itemname},
            wield_item = self.itemstring,
        })
    end,
})

function add_item(pos, item_name, yaw)
    local new_item = add_entity(pos, "item")
    if (new_item and new_item:get_luaentity()) then
        new_item:get_luaentity():set_item(item_name)
        pos.y = pos.y + new_item:get_luaentity().scale
        new_item:set_pos(pos)
        new_item:set_yaw(yaw)
    end
end