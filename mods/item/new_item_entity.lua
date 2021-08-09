local add_entity = minetest.add_entity

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
        visual_size  = {x = 0.21, y = 0.21},
    },

    set_item = function(self, item)
        local stack = ItemStack(item or self.itemstring)
        self.itemstring = stack:to_string()
        if self.itemstring == "" then
            self.object:remove()
            return
        end
        local itemname = stack:is_known() and stack:get_name() or "unknown"
        self.object:set_properties({
            textures = {itemname},
            wield_item = self.itemstring,
        })
    end,
})

function add_item(pos, item_name)
    local new_item = add_entity(pos, "item")
    if (new_item) then
        new_item:set_item(item_name)
    end
end