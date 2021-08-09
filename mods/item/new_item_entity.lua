local add_entity = minetest.add_entity
local serialize = minetest.serialize
local deserialize = minetest.deserialize
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

    on_punch = function(self, player)
        -- check if player has free hand
        local inventory = player:get_inventory()

        local stack_1 = player:get_wielded_item():get_name()
        local stack_2 = inventory:get_stack("secondary", 1):get_name()

        if (stack_1 == "") then
            player:set_wielded_item(self.itemstring)
            self.object:remove()
            return
        elseif (stack_2 == "") then
            inventory:set_stack("secondary", 1, self.itemstring)
            self.object:remove()
            return
        end
    end,

    -- when an item "goes to sleep"
    get_staticdata = function(self)
        return serialize({
            itemstring = self.itemstring,
        })
    end,

    -- when an item "wakes up"
    on_activate = function(self, staticdata, dtime_s)
        -- do not bother with newly created items
        if (dtime_s == 0) then
            return
        end

        if string.sub(staticdata, 1, string.len("return")) == "return" then
            local data = deserialize(staticdata)
            if data and type(data) == "table" then
                self.itemstring = data.itemstring
            end
        else
            self.itemstring = staticdata
        end

        -- do not allow corrupted items to exist
        if (not self.itemstring) then
            self.object:remove()
        end

        self:set_item(self.itemstring)
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