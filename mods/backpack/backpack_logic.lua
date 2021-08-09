local get_connected_players = minetest.get_connected_players
local register_globalstep = minetest.register_globalstep
local is_player = minetest.is_player
local add_entity = minetest.add_entity
local vector_multiply = vector.multiply

local backpack_events = {}
local players_backpacks = {}


local function add_backpack_gui_entity(pos,item_name)
    local entity = add_entity(pos, "backpack_gui_entity")
    if (entity) then
        entity:get_luaentity():set_item(item_name)
        return(entity)
    end
    return(nil)
end

minetest.register_entity(":backpack_gui_selection_entity", {
    initial_properties = {
        hp_max           = 1,
        visual           = "upright_sprite",
        physical         = false,
        textures         = {"backpack_selection.png"},
        is_visible       = true,
        pointable        = false,
        collide_with_objects = false,
        collisionbox = {0,0,0,0,0,0},
        selectionbox = {0,0,0,0,0,0},
        visual_size  = {x = 0.4, y = 0.4},
    },

})

minetest.register_entity(":backpack_gui_anchor_entity", {
    initial_properties = {
        hp_max           = 1,
        visual           = "sprite",
        physical         = false,
        textures         = {"concrete.png"},
        is_visible       = true,
        pointable        = false,
        collide_with_objects = false,
        collisionbox = {0,0,0,0,0,0},
        selectionbox = {0,0,0,0,0,0},
        visual_size  = {x = 0, y = 0},
    },

    slot_1 = nil,
    slot_2 = nil,
    slot_3 = nil,
    slot_4 = nil,
    slot_5 = nil,
    slot_6 = nil,
    slot_7 = nil,
    slot_8 = nil,
    slot_9 = nil,
    slot_10 = nil,
    selection_entity = nil,
    owner = nil,

    old_index = 1,

    -- slots are strings
    create_gui = function(self, player)
        self.owner = player
        local name = player:get_player_name()
        local backpack_contents = players_backpacks[name]
        local pos = player:get_pos()

        local x = -2
        local y = 1

        for i = 1,10 do
            local current_index = backpack_contents["slot_"..tostring(i)]

            if (current_index and current_index ~= "") then
                local gui_entity = add_backpack_gui_entity(pos, current_index)
                if (gui_entity) then
                    gui_entity:set_attach(self.object, "", {x=x * 4,y=y*4,z=0}, {x=0,y=0,z=0}, true)
                    if (i == 1) then
                        local selection_entity = add_entity(pos, "backpack_gui_selection_entity")
                        if (selection_entity) then
                            selection_entity:set_attach(self.object, "", {x=x * 4,y=y*4,z=0}, {x=0,y=0,z=0}, true)
                            self.selection_entity = selection_entity
                        end
                    end
                    -- dynamically linked object reference
                    self["slot_"..tostring(i)] = gui_entity
                end
            end

            x = x + 1

            if (i == 5) then
                x = -2
                y = 0
            end
        end
    end,

    on_step = function(self)
        if (self.owner and is_player(self.owner)) then
            local index = self.owner:get_wield_index()

            -- index has changed, update
            if (self.old_index ~= index) then
                local x = index - 3
                local y = 1

                if (index > 5) then
                    x = index - 5 - 3
                    y = 0
                end

                self.selection_entity:set_attach(self.object, "", {x=x * 4,y=y*4,z=0}, {x=0,y=0,z=0}, true)
            end

            self.old_index = index
        end
    end,

    clean_up = function(self)
        -- clean up inventory entities
        for i = 1,10 do
            local current_index = self["slot_"..tostring(i)]
            if (current_index and current_index:get_luaentity()) then
                current_index:remove()
            end
        end

        -- clean up selection entity
        if (self.selection_entity and self.selection_entity:get_luaentity()) then
            self.selection_entity:remove()
        end

        -- clean up self
        self.object:remove()
    end
})

minetest.register_entity(":backpack_gui_entity", {
    initial_properties = {
        hp_max           = 1,
        visual           = "wielditem",
        physical         = false,
        textures         = {""},
        is_visible       = true,
        pointable        = false,
        collide_with_objects = false,
        collisionbox = {0,0,0,0,0,0},
        selectionbox = {0,0,0,0,0,0},
        visual_size  = {x = 0.2, y = 0.2},
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

local function get_if_player_reaching_for_backpack(player)
    local control_bits = player:get_player_control_bits()

    -- zoom
    if (control_bits >= 512) then
        control_bits = control_bits - 512
    end

    -- place
    if (control_bits >= 256) then
        control_bits = control_bits - 256
    end

    -- dig
    if (control_bits >= 128) then
        control_bits = control_bits - 128
    end

    -- sneak
    if (control_bits >= 64) then
        control_bits = control_bits - 64
    end

    -- aux1
    if (control_bits >= 32) then
        return(true)
    end

    return(false)
end


register_globalstep(function(dtime)
    for _,player in pairs(get_connected_players()) do

        local name = player:get_player_name()

        local event = backpack_events[name]

        -- check to see if player is trying to get to their backpack
        if (not event) then
            if (get_if_player_reaching_for_backpack(player) and players_backpacks[name]) then
                print("player is trying to reach for backpack")
                backpack_events[name] = {stage = 1, timer = 0}
                -- player is locked in place until they're holding their backpack
                player:set_physics_override({speed = 0})
                local velocity = player:get_velocity()
                player:add_velocity(vector_multiply(velocity, -1))
            end
        -- player is in backpack animation event
        else
            event.timer = event.timer + dtime

            -- grabbing for backpack
            if (event.stage == 1 and event.timer >= 0.8) then
                -- timer is reached, attach backpack, next stage
                attach_player_backpack_to_hand(player)
                event.stage = 2
                event.timer = 0
                -- bringing backpack over head, and positioning arms
            elseif (event.stage == 2 and event.timer >= 0.8) then
                -- timer is reached, open backpack
                set_player_backpack_opened(player, true)
                event.stage = 3
                event.timer = 0
                -- player can now move around
                player:set_physics_override({speed = 1})

                -- spawn in gui anchor
                local pos = player:get_pos()
                local anchor_entity = add_entity(pos, "backpack_gui_anchor_entity")
                anchor_entity:set_attach(get_player_backpack_entity(player), "", {x=0,y=3,z=10}, {x=0,y=0,z=0}, true)
                anchor_entity:get_luaentity():create_gui(player)
                event.gui_entity = anchor_entity

                -- this is used to scroll the inventory properly, it is a hack
                player:get_inventory():set_size("main", 10)
                player:hud_set_hotbar_itemcount(10)

                -- holding backpack in front of player
            elseif (event.stage == 3) then
                -- poll Q (drop) for dropping a backpack on the ground

                -- player wants to put backpack away
                if (get_if_player_reaching_for_backpack(player)) then
                    event.stage = 4
                    event.timer = 0
                    -- close backpack
                    set_player_backpack_opened(player, false)
                    -- player is locked in place until they're done putting away their backpack
                    player:set_physics_override({speed = 0})
                    local velocity = player:get_velocity()
                    player:add_velocity(vector_multiply(velocity, -1))

                    -- reset the inventory, this is a hack
                    -- this will crash the game when a player presses Q outside the hotbar/inventory location
                    -- todo: fix this somehow
                    player:get_inventory():set_size("main", 1)
                    player:hud_set_hotbar_itemcount(1)

                    -- delete backpack gui
                    if (event.gui_entity and event.gui_entity:get_luaentity()) then
                        event.gui_entity:get_luaentity():clean_up()
                    end
                    -- clean memory
                    event.gui_entity = nil
                end
            elseif (event.stage == 4 and event.timer >= 0.8) then
                -- player's backpack is now back onto their back
                reattach_player_backpack_to_back(player)
                event.stage = 5
                event.timer = 0
            elseif (event.stage == 5 and event.timer >= 0.8) then
                -- animation complete, unlock player
                player:set_physics_override({speed = 1})
                backpack_events[name] = nil
            end
        end
    end
end)

function get_player_backpack_event(player_name)
    return backpack_events[player_name] and backpack_events[player_name].stage
end

function player_has_backpack_open(player)
    local name = player:get_player_name()
    return backpack_events[name] ~= nil
end

minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()

    -- this is a debug and needs to be loaded from a mod save file
    if (not players_backpacks[name]) then
        players_backpacks[name] = {
            slot_1 = "machine_gun",
            slot_2 = "machine_gun",
            slot_3 = "machine_gun",
            slot_4 = "machine_gun",
            slot_5 = "machine_gun",
            slot_6 = "machine_gun",
            slot_7 = "machine_gun",
            slot_8 = "machine_gun",
            slot_9 = "machine_gun",
            slot_10 = "machine_gun"
        }

        minetest.after(0, function()
            set_player_backpack_visibility(player, true)
        end)
    end
end)