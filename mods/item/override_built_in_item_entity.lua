minetest.register_entity(":__builtin:item", {
    initial_properties = {
        hp_max           = 1,
        visual           = "sprite",
        physical         = false,
        textures         = {""},
        is_visible       = true,
        pointable        = true,

        collide_with_objects = false,
        collisionbox = {0,0,0,0,0,0},
        selectionbox = {-0.21, -0.21, -0.21, 0.21, 0.21, 0.21},
        visual_size  = {x = 0.21, y = 0.21},
    },
    set_item = function(self, item)
        local stack = ItemStack(item or self.itemstring)
        self.itemstring = stack:to_string()
        if self.itemstring == "" then
            -- item not yet known
            return
        end
        local itemname = stack:is_known() and stack:get_name() or "unknown"
        self.object:set_properties({
            textures = {itemname},
            wield_item = self.itemstring,
        })
    end,
    on_activate = function(self, staticdata, dtime_s)
        if string.sub(staticdata, 1, string.len("return")) == "return" then
            local data = minetest.deserialize(staticdata)
            if data and type(data) == "table" then
                self.itemstring = data.itemstring
            end
        else
            self.itemstring = staticdata
        end
        self.object:set_armor_groups({immortal = 1})
        self.set_item(self,self.itemstring)
    end
})