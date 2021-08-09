local get_connected_players = minetest.get_connected_players
local register_globalstep = minetest.register_globalstep
local serialize = minetest.serialize
local deserialize = minetest.deserialize
local is_player = minetest.is_player
local mod_storage = minetest.get_mod_storage()
local add_entity = minetest.add_entity
local vector_multiply = vector.multiply

local backpack_events = {}
local player_backpacks = {}


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

    on_activate = function(self, staticdata, dtime_s)
        -- do not bother with newly created items
        if (dtime_s ~= 0) then
            self.object:remove()
        end
    end
})

minetest.register_entity(":backpack_gui_anchor_entity", {
    initial_properties = {
        hp_max           = 1,
        visual           = "sprite",
        physical         = false,
        textures         = {"invisible.png"},
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

    on_activate = function(self, staticdata, dtime_s)
        -- do not bother with newly created items
        if (dtime_s ~= 0) then
            self.object:remove()
        end
    end,

    -- slots are strings
    create_gui = function(self, player)
        self.owner = player
        local name = player:get_player_name()
        local backpack_contents = player_backpacks[name]
        local pos = player:get_pos()

        local x = -2
        local y = 1

        for i = 1,10 do
            local current_index = backpack_contents["slot_"..tostring(i)]

            if (current_index and current_index ~= "") then
                local gui_entity = add_backpack_gui_entity(pos, current_index)
                if (gui_entity) then
                    gui_entity:set_attach(self.object, "", {x=x * 4,y=y*4,z=0}, {x=0,y=0,z=0}, true)
                    -- dynamically linked object reference
                    self["slot_"..tostring(i)] = gui_entity
                end
            end

            if (i == 1) then
                local selection_entity = add_entity(pos, "backpack_gui_selection_entity")
                if (selection_entity) then
                    selection_entity:set_attach(self.object, "", {x=x * 4,y=y*4,z=0}, {x=0,y=0,z=0}, true)
                    self.selection_entity = selection_entity
                end
            end

            x = x + 1

            if (i == 5) then
                x = -2
                y = 0
            end
        end
    end,

    rebuild_slot = function(self,slot_number)

        local name = self.owner:get_player_name()
        local backpack_contents = player_backpacks[name]

        local current_index = backpack_contents["slot_"..tostring(slot_number)]

        if (current_index and current_index ~= "") then

            -- clean up slot entity
            local existing_entity = self["slot_"..tostring(slot_number)]
            if (existing_entity and existing_entity:get_luaentity()) then
                existing_entity:remove()
            end

            local x = slot_number - 3
            local y = 1

            if (slot_number > 5) then
                x = slot_number - 5 - 3
                y = 0
            end

            -- add new slot entity
            local gui_entity = add_backpack_gui_entity(self.object:get_pos(), current_index)
            if (gui_entity) then
                gui_entity:set_attach(self.object, "", {x=x * 4,y=y*4,z=0}, {x=0,y=0,z=0}, true)
                -- dynamically linked object reference
                self["slot_"..tostring(slot_number)] = gui_entity
            end
        -- remove existing slot entity
        elseif (not current_index or (current_index and current_index == "")) then
            local existing_entity = self["slot_"..tostring(slot_number)]
            if (existing_entity and existing_entity:get_luaentity()) then
                existing_entity:remove()
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

    on_activate = function(self, staticdata, dtime_s)
        -- do not bother with newly created items
        if (dtime_s ~= 0) then
            self.object:remove()
        end
    end,

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

local function is_trying_to_drop_backpack(player)
    local control_bits = player:get_player_control_bits()

    -- zoom
    if (control_bits >= 512) then
        return(true)
    end

    return(false)
end



local function is_swapping_items_backpack(player)
    local control_bits = player:get_player_control_bits()

    local return_bit = 0

    -- zoom
    if (control_bits >= 512) then
        control_bits = control_bits - 512
    end

    -- place
    if (control_bits >= 256) then
        control_bits = control_bits - 256
        return_bit = return_bit - 1
    end

    -- dig
    if (control_bits >= 128) then
        control_bits = control_bits - 128
        return_bit = return_bit + 1
    end

    return(return_bit)
end

register_globalstep(function(dtime)
    for _,player in pairs(get_connected_players()) do

        local name = player:get_player_name()

        local event = backpack_events[name]

        -- check to see if player is trying to get to their backpack
        if (not event) then
            if (get_if_player_reaching_for_backpack(player) and player_backpacks[name] and not player_is_climbing(name)) then
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
                -- poll Z (zoom) for dropping a backpack on the ground
                if (is_trying_to_drop_backpack(player) and not player_is_climbing(name) and backpack_events[name] and backpack_events[name].stage == 3) then
                    local pos = player:get_pos()
                    pos.y = pos.y + 0.5
                    local backpack_entity = add_entity(pos, "backpack_ground")

                    if (backpack_entity and backpack_entity:get_luaentity()) then
                        local lua_entity = backpack_entity:get_luaentity()

                        backpack_entity:set_yaw(player:get_look_horizontal())

                        local current_player_backpack = player_backpacks[name]

                        lua_entity.slot_1 = current_player_backpack.slot_1
                        lua_entity.slot_2 = current_player_backpack.slot_2
                        lua_entity.slot_3 = current_player_backpack.slot_3
                        lua_entity.slot_4 = current_player_backpack.slot_4
                        lua_entity.slot_5 = current_player_backpack.slot_5
                        lua_entity.slot_6 = current_player_backpack.slot_6
                        lua_entity.slot_7 = current_player_backpack.slot_7
                        lua_entity.slot_8 = current_player_backpack.slot_8
                        lua_entity.slot_9 = current_player_backpack.slot_9
                        lua_entity.slot_10 = current_player_backpack.slot_10
                    end

                    -- delete backpack gui
                    if (event.gui_entity and event.gui_entity:get_luaentity()) then
                        event.gui_entity:get_luaentity():clean_up()
                    end

                    backpack_events[name] = nil
                    set_player_backpack_visibility(player, false)
                    player_backpacks[name] = nil
                    mod_storage:set_string(name.."_backpack_data", "")

                    set_player_item_swap_cooldown(player, 0.5)
                -- player wants to put backpack away
                elseif (get_if_player_reaching_for_backpack(player)) then
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
                -- index if player wants to put/remove items from/into backpack
                elseif (is_swapping_items_backpack(player) ~= 0 and not event.swap_cooldown) then
                    local bits = is_swapping_items_backpack(player)

                    local index = player:get_wield_index()

                    if (bits > 0) then
                        -- do the swap
                        local inventory = player:get_inventory()

                        local stack_1 = inventory:get_stack("main", 1):get_name()
                        local stack_2 = player_backpacks[name]["slot_"..tostring(index)]

                        inventory:set_stack("main", 1, stack_2)
                        player_backpacks[name]["slot_"..tostring(index)] = stack_1

                       event.gui_entity:get_luaentity():rebuild_slot(index)

                        event.swap_cooldown = 0.25
                    elseif (bits < 0) then

                        -- do the swap
                        local inventory = player:get_inventory()

                        local stack_1 = inventory:get_stack("secondary", 1):get_name()
                        local stack_2 = player_backpacks[name]["slot_"..tostring(index)]

                        inventory:set_stack("secondary", 1, stack_2)
                        player_backpacks[name]["slot_"..tostring(index)] = stack_1

                        event.gui_entity:get_luaentity():rebuild_slot(index)

                        event.swap_cooldown = 0.25
                    end
                end

                -- the cool_down for swapping items in and out of the backpack
                if (event.swap_cooldown) then
                    event.swap_cooldown = event.swap_cooldown - dtime
                    if (event.swap_cooldown <= 0) then
                        event.swap_cooldown = nil
                    end
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


minetest.register_entity(":backpack_ground", {
    initial_properties = {
        hp_max           = 1,
        visual           = "wielditem",
        physical         = false,
        textures         = {"backpack_ground"},
        is_visible       = true,
        pointable        = true,
        collide_with_objects = false,
        collisionbox = {0, 0, 0, 0, 0, 0},
        selectionbox = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3},
        -- this should be 1/1.1 but that does not work properly
        visual_size  = {x = 0.7, y = 0.7},
    },

    slot_1 = "",
    slot_2 = "",
    slot_3 = "",
    slot_4 = "",
    slot_5 = "",
    slot_6 = "",
    slot_7 = "",
    slot_8 = "",
    slot_9 = "",
    slot_10 = "",

    -- when a backpack "goes to sleep"
    get_staticdata = function(self)
        return serialize({
            slot_1 = self.slot_1,
            slot_2 = self.slot_2,
            slot_3 = self.slot_3,
            slot_4 = self.slot_4,
            slot_5 = self.slot_5,
            slot_6 = self.slot_6,
            slot_7 = self.slot_7,
            slot_8 = self.slot_8,
            slot_9 = self.slot_9,
            slot_10 = self.slot_10,
        })
    end,

    on_punch = function(self, player)
        local name = player:get_player_name()
        -- player equips backpack and is in open event so they can put it back down quickly
        if (not player_has_backpack(player)) then
            player_backpacks[name] = {
                slot_1 = self.slot_1,
                slot_2 = self.slot_2,
                slot_3 = self.slot_3,
                slot_4 = self.slot_4,
                slot_5 = self.slot_5,
                slot_6 = self.slot_6,
                slot_7 = self.slot_7,
                slot_8 = self.slot_8,
                slot_9 = self.slot_9,
                slot_10 = self.slot_10,
            }

            set_player_backpack_visibility(player, true)

            backpack_events[name] = {stage = 2, timer = 1}

            local event = backpack_events[name]
            -- stop instantly clicking
            event.swap_cooldown = 0.5

            -- this is used to scroll the inventory properly, it is a hack
            player:get_inventory():set_size("main", 10)
            player:hud_set_hotbar_itemcount(10)

            attach_player_backpack_to_hand(player)

            mod_storage:set_string(name.."_backpack_data", serialize(player_backpacks[name]))

            self.object:remove()
        end
    end,

    -- when a backpack "wakes up"
    on_activate = function(self, staticdata, dtime_s)
        if string.sub(staticdata, 1, string.len("return")) == "return" then
            local data = deserialize(staticdata)
            if data and type(data) == "table" then
                self.itemstring = data.itemstring
                self.slot_1 = data.slot_1
                self.slot_2 = data.slot_2
                self.slot_3 = data.slot_3
                self.slot_4 = data.slot_4
                self.slot_5 = data.slot_5
                self.slot_6 = data.slot_6
                self.slot_7 = data.slot_7
                self.slot_8 = data.slot_8
                self.slot_9 = data.slot_9
                self.slot_10 = data.slot_10
            end
        -- a corrupted backpack
        elseif (dtime_s ~= 0) then
            self.object:remove()
        end
    end,
})

function get_player_backpack_event(player_name)
    return(backpack_events[player_name] and backpack_events[player_name].stage)
end

function player_has_backpack_open(player)
    local name = player:get_player_name()
    return(backpack_events[name] ~= nil)
end

function player_has_backpack(player)
    local name = player:get_player_name()
    return(player_backpacks[name] ~= nil)
end


minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    local serialized_data = mod_storage:get_string(name.."_backpack_data")
    -- deserialize the player backpack data
    if (serialized_data ~= "") then
        local data = deserialize(serialized_data)
        player_backpacks[name] = data
        minetest.after(0, function()
            set_player_backpack_visibility(player, true)
        end)
    end
end)

minetest.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    if (player_backpacks[name]) then
        mod_storage:set_string(name.."_backpack_data", serialize(player_backpacks[name]))
        player_backpacks[name] = nil
    else
        mod_storage:set_string(name.."_backpack_data", "")
    end
end)


minetest.register_on_shutdown(function()
    for name,_ in pairs(player_backpacks) do
        mod_storage:set_string(name.."_backpack_data", serialize(player_backpacks[name]))
        player_backpacks[name] = nil
    end
end)
