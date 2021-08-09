local get_player_by_name = minetest.get_player_by_name
local is_climbing_over = player_climbing_over
local is_climbing_ladder = player_climbing_ladder
local is_on_ladder = player_on_ladder
local is_climbing_off_ladder = player_climbing_off_ladder
local is_climbing_onto_ladder_from_top = player_climbing_onto_ladder_from_top
local get_item_group = minetest.get_item_group

-- avoids table look ups
local stand_begin = 0
local stand_end = 20

local sit_begin = 25
local sit_end = 45

local walk_begin = 50
local walk_end = 70

local hit_begin = 100
local hit_end = 120

local walk_hit_begin = 75
local walk_hit_end = 95

local aim_begin = 125
local aim_end = 145

local aim_walk_begin = 150
local aim_walk_end = 170

local climb_over_begin = 175
local climb_over_end = 195

local lay_begin = 200
local lay_end = 220

local ladder_climb_begin = 225
local ladder_climb_end = 245

local ladder_stand_begin = 250
local ladder_stand_end = 270

local ladder_climb_off_begin = 275
local ladder_climb_off_end = 295

local ladder_climb_on_from_top_begin = 300
local ladder_climb_on_from_top_end = 320

-- begin backpack animations

local backpack_grab_stage_1_begin = 325
local backpack_grab_stage_1_end = 345

-- backpack becomes attached

local backpack_grab_stage_2_begin = 350
local backpack_grab_stage_2_end = 370

-- backpack is now presented in players view
-- these animations are reversed when putting away backpack

local backpack_stand_begin = 370
local backpack_stand_end = 370

local backpack_walk_begin = 375
local backpack_walk_end = 395

local backpack_put_away_stage_1_begin = 400
local backpack_put_away_stage_1_end = 420

local backpack_put_away_stage_2_begin = 425
local backpack_put_away_stage_2_end = 445

-- end backpack animations


--[[
    current_animation:
    16 - putting away backpack - stage 2
    15 - putting away backpack - stage 1
    14 - standing with backpack
    13 - walking with backpack
    12 - grabbing backpack - stage 2
    11 - grabbing backpack - stage 1
    10 - climbing onto ladder from top
    9 - climbing off ladder
    8 - standing on ladder
    7 - climbing a ladder
    6 - holding gun walking
    5 - holding gun
    4 - climbing over
    3 - walk hit
    2 - walk
    1 - hit
    0 - stand
]]--

local models = {}

local function is_moving_with_backpack(player)
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
        control_bits = control_bits - 32
    end

    -- jump
    if (control_bits >= 16) then
        control_bits = control_bits - 16
    end

    -- right
    if (control_bits >= 8) then
        return(true)
    end

    -- left
    if (control_bits >= 4) then
        return(true)
    end

    -- down
    if (control_bits >= 2) then
        return(true)
    end

    -- up
    if (control_bits >= 1) then
        return(true)
    end

    return(false)
end

local function player_is_aiming(player)
    local control_bits = player:get_player_control_bits()

    -- zoom
    if (control_bits >= 512) then
        control_bits = control_bits - 512
    end

    -- place
    if (control_bits >= 256) then
        control_bits = control_bits - 256
        return true
    end
    return false
end


minetest.register_entity(":player_holding_item", {
    initial_properties = {
        hp_max           = 1,
        visual           = "wielditem",
        physical         = false,
        textures         = {""},
        is_visible       = false,
        pointable        = false,
        collide_with_objects = false,
        collisionbox = {0, 0, 0, 0, 0, 0},
        selectionbox = {0, 0, 0, 0, 0, 0},
        visual_size  = {x = 0.2, y = 0.2},
    },
    itemstring = "",
    gun = false,
    aim_adjusted = false,
    was_aiming = false,
    set_item = function(self, item)

        local visible = (item ~= "")

        if (self.itemstring == item) then
            return
        end

        if (item == "") then
            item = "invisible_hand"
        end

        local stack = ItemStack(item or self.itemstring)
        self.itemstring = stack:to_string()
        local item_texture = (stack:is_known() and stack:get_definition().inventory_image) or "unknown"
        local scale_x = get_item_group(self.itemstring, "scale_x")
        local scale_y = get_item_group(self.itemstring, "scale_y")
        local scale_z = get_item_group(self.itemstring, "scale_z")
        self.object:set_properties({
            textures = {item_texture},
            wield_item = self.itemstring,
            visual_size  = {x = scale_x, y = scale_y, z = scale_z},
            is_visible = visible,
        })

        self.gun = get_item_group(item, "gun") > 0
    end,
    attached_player = nil,
    timer = 0,
    on_step = function(self,dtime)
        self.timer = self.timer + dtime

        if (self.attached_player == nil) then
            self.object:remove()
            return
        end

        local player = get_player_by_name(self.attached_player)

        if (player == nil) then
            self.object:remove()
            return
        end

        -- wielded item entity does not need to update often
        if (self.timer >= 0.25) then

            local item = player:get_inventory():get_stack("main", 1):get_name()

            self.set_item(self,item)
        end

        -- allow player to aim down gun sights
        if (self.gun) then
            local player = get_player_by_name(self.attached_player)
            local player_aiming = player_is_aiming(player)
            if (player_aiming and not self.aim_adjusted and not player_has_backpack_open(player) and not player_is_climbing(self.attached_player)) then
                local attached,_ = self.object:get_attach()
                self.object:set_attach(attached,"Arm_Right", {x=0.5,y=6,z=1}, {x=90,y=0,z=-75}, true)
                self.aim_adjusted = true
            elseif (not player_aiming and self.aim_adjusted) then
                local attached,_ = self.object:get_attach()
                self.object:set_attach(attached,"Arm_Right", {x=0,y=6,z=1}, {x=90,y=0,z=-90}, true)
                self.aim_adjusted = false
            end
        elseif (self.aim_adjusted) then
            local attached,_ = self.object:get_attach()
            self.object:set_attach(attached,"Arm_Right", {x=0,y=6,z=1}, {x=90,y=0,z=-90}, true)
            self.aim_adjusted = false
        end

    end,
})


minetest.register_entity(":player_holding_item_left_hand", {
    initial_properties = {
        hp_max           = 1,
        visual           = "wielditem",
        physical         = false,
        textures         = {""},
        is_visible       = false,
        pointable        = false,
        collide_with_objects = false,
        collisionbox = {0, 0, 0, 0, 0, 0},
        selectionbox = {0, 0, 0, 0, 0, 0},
        visual_size  = {x = 0.2, y = 0.2},
    },
    itemstring = "",
    set_item = function(self, item)
        local visible = (item ~= "")

        if (self.itemstring == item) then
            return
        end

        if (item == "") then
            item = "invisible_hand"
        end

        local stack = ItemStack(item or self.itemstring)
        self.itemstring = stack:to_string()
        local item_texture = (stack:is_known() and stack:get_definition().inventory_image) or "unknown"
        local scale_x = get_item_group(self.itemstring, "scale_x")
        local scale_y = get_item_group(self.itemstring, "scale_y")
        local scale_z = get_item_group(self.itemstring, "scale_z")

        self.object:set_properties({
            textures = {item_texture},
            wield_item = self.itemstring,
            visual_size  = {x = scale_x, y = scale_y, z = scale_z},
            is_visible = visible,
        })

    end,
    attached_player = nil,
    timer = 0,
    on_step = function(self,dtime)
        self.timer = self.timer + dtime

        if (self.attached_player == nil) then
            self.object:remove()
            return
        end

        local player = get_player_by_name(self.attached_player)

        if (player == nil) then
            self.object:remove()
            return
        end

        -- wielded item entity does not need to update often
        if (self.timer >= 0.25) then
            local item = player:get_inventory():get_stack("secondary", 1):get_name()
            self.set_item(self,item)
        end
    end,
})



minetest.register_entity(":backpack", {
    initial_properties = {
        hp_max           = 1,
        visual           = "wielditem",
        physical         = false,
        textures         = {"backpack"},
        is_visible       = false,
        pointable        = false,
        collide_with_objects = false,
        collisionbox = {0, 0, 0, 0, 0, 0},
        selectionbox = {0, 0, 0, 0, 0, 0},
        -- this should be 1/1.1 but that does not work properly
        visual_size  = {x = 0.7, y = 0.7},
    },
    attached_player = nil,
    timer = 0,
    set_opened = function(self, opened)
        local status = ""
        if (opened) then
            status = "open_backpack"
        else
            status = "backpack"
        end
        self.object:set_properties({
            textures = {status},
        })
    end,
    on_step = function(self,dtime)
        self.timer = self.timer + dtime
        if (self.timer > 0.25) then
            self.timer = 0
            if (self.attached_player == nil) then
                self.object:remove()
                return
            end
            if (get_player_by_name(self.attached_player) == nil) then
                self.object:remove()
                return
            end
        end
    end,
})


minetest.register_entity(":player_model",{
    visual = "mesh",
    mesh = "player.b3d",
    textures = {"player.png"},
    pointable = false,
    visual_size = {x = 1.1, y = 1.1},
    attached_player = nil,
    current_animation = 0,
    on_step = function(self)
        if (self.attached_player == nil) then
            self.object:remove()
            return
        end

        local player = get_player_by_name(self.attached_player)

        if (player == nil) then
            self.object:remove()
            return
        end

        -- digest player look pitch - goes first to always function
        self.object:set_bone_position("Head",{x = 0, y = 6.25, z = 0}, {x = player:get_look_vertical() * -45, y = 0, z = 0})

        -- this blocks the entire function to complete this animation
        local backpack_event = get_player_backpack_event(self.attached_player)
        if (backpack_event) then
            if (backpack_event == 1) then
                if (self.current_animation ~= 11) then
                    self.object:set_animation({ x = backpack_grab_stage_1_begin, y = backpack_grab_stage_1_end }, 23, 0, false)
                    self.current_animation = 11
                end
            elseif (backpack_event == 2) then
                if (self.current_animation ~= 12) then
                    self.object:set_animation({ x = backpack_grab_stage_2_begin, y = backpack_grab_stage_2_end }, 23, 0, false)
                    self.current_animation = 12
                end
            elseif (backpack_event == 3) then
                if (is_moving_with_backpack(player)) then
                    if (self.current_animation ~= 13) then
                        self.object:set_animation({ x = backpack_walk_begin, y = backpack_walk_end }, 20, 0, true)
                        self.current_animation = 13
                    end
                else
                    if (self.current_animation ~= 14) then
                        self.object:set_animation({ x = backpack_stand_begin, y = backpack_stand_end }, 20, 0, false)
                        self.current_animation = 14
                    end
                end
            elseif (backpack_event == 4) then
                if (self.current_animation ~= 15) then
                    self.object:set_animation({ x = backpack_put_away_stage_1_begin, y = backpack_put_away_stage_1_end }, 20, 0, false)
                    self.current_animation = 15
                end
            elseif(backpack_event == 5) then
                if (self.current_animation ~= 16) then
                    self.object:set_animation({ x = backpack_put_away_stage_2_begin, y = backpack_put_away_stage_2_end }, 20, 0, false)
                    self.current_animation = 16
                end
            end
            return
        end


        -- this blocks the entire function to complete this animation
        if (is_climbing_onto_ladder_from_top(self.attached_player)) then
            if (self.current_animation ~= 10) then
                self.object:set_animation({ x = ladder_climb_on_from_top_begin, y = ladder_climb_on_from_top_end }, 23, 0, false)
                self.current_animation = 10
            end
            return
        end
        -- this blocks the entire function to complete this animation
        if (is_climbing_off_ladder(self.attached_player)) then
            if (self.current_animation ~= 9) then
                self.object:set_animation({ x = ladder_climb_off_begin, y = ladder_climb_off_end }, 23, 0, false)
                self.current_animation = 9
            end
            return
        end

        -- this blocks the entire function to hold the animation
        if (is_on_ladder(self.attached_player)) then
            if (self.current_animation ~= 8) then
                self.object:set_animation({ x = ladder_stand_begin, y = ladder_stand_end }, 28, 0, true)
                self.current_animation = 8
            end
            return
        end

        -- this blocks the entire function to hold the animation
        if (is_climbing_ladder(self.attached_player)) then
            if (self.current_animation ~= 7) then
                self.object:set_animation({ x = ladder_climb_begin, y = ladder_climb_end }, 28, 0, true)
                self.current_animation = 7
            end
            return
        end

        -- this blocks the entire function to complete the animation
        if (is_climbing_over(self.attached_player)) then
            if (self.current_animation ~= 4) then
                self.object:set_animation({ x = climb_over_begin, y = climb_over_end }, 28, 0, false)
                self.current_animation = 4
            end
            return
        end

        -- a cache happy way to intercept player controls

        local crouching = false
        local moving = false
        local hitting = false
        local aiming = false

        local holding_gun = get_item_group(player:get_inventory():get_stack("main", 1):get_name(), "gun") > 0

        local control_bits = player:get_player_control_bits()

        -- zoom
        if (control_bits >= 512) then
            control_bits = control_bits - 512
        end

        -- place
        if (control_bits >= 256) then
            control_bits = control_bits - 256
            if (holding_gun) then
                aiming = true
            end
        end

        -- dig
        if (control_bits >= 128) then
            control_bits = control_bits - 128
            hitting = true
        end
        -- sneak
        if (control_bits >= 64) then
            control_bits = control_bits - 64
            crouching = true
        end

        -- aux1
        if (control_bits >= 32) then
            control_bits = control_bits - 32
        end

        -- jump
        if (control_bits >= 16) then
            control_bits = control_bits - 16
        end



        -- right
        if (control_bits >= 8) then
            control_bits = control_bits - 8
            moving = true
        end

        -- left
        if (control_bits >= 4) then
            control_bits = control_bits - 4
            moving = true
        end

        -- down
        if (control_bits >= 2) then
            control_bits = control_bits - 2
            moving = true
        end

        -- up
        if (control_bits >= 1) then
            control_bits = control_bits - 1
            moving = true
        end


        -- digest booleans and do animation
        if (aiming and moving and self.current_animation ~= 6) then
            self.object:set_animation({ x = aim_walk_begin, y = aim_walk_end }, 20, 0, true)
            self.current_animation = 6
        elseif (aiming and not moving and self.current_animation ~= 5) then
            self.object:set_animation({ x = aim_begin, y = aim_end }, 20, 0, true)
            self.current_animation = 5
        elseif (not aiming and moving and hitting and self.current_animation ~= 3) then
            self.object:set_animation({ x = walk_hit_begin, y = walk_hit_end }, 20, 0, true)
            self.current_animation = 3
        elseif (not aiming and moving and not hitting and self.current_animation ~= 2) then
            self.object:set_animation({ x = walk_begin, y = walk_end }, 20, 0, true)
            self.current_animation = 2
        elseif (not aiming and hitting and not moving and self.current_animation ~= 1) then
            self.object:set_animation({ x = hit_begin, y = hit_end }, 20, 0, true)
            self.current_animation = 1
        elseif (not aiming and not hitting and not moving and self.current_animation ~= 0) then
            self.object:set_animation({ x = stand_begin, y = stand_end }, 20, 0, true)
            self.current_animation = 0
        end


        -- digest player pitch when aiming to move arms
        if (aiming) then
            self.object:set_bone_position("Arm_Left_Base",{x = 0, y = 5.25, z = -1.5}, {x = player:get_look_vertical() * -50, y = 0, z = 0})
            self.object:set_bone_position("Arm_Right_Base",{x = 0, y = 5.25, z = -1.5}, {x = player:get_look_vertical() * -50, y = 0, z = 0})
            self.was_aiming = true
        elseif (self.was_aiming) then
            self.object:set_bone_position("Arm_Left_Base",{x = 0, y = 5.25, z = 0}, {x = 0, y = 0, z = 0})
            self.object:set_bone_position("Arm_Right_Base",{x = 0, y = 5.25, z = 0}, {x = 0, y = 0, z = 0})
            self.was_aiming = false
        end


        -- crouching needs an animation
        --[[
        if (crouching) then
            print("I am crouching")
        end

        if (moving) then
            print("I am moving")
        end

        if (hitting) then
            print("I am hitting")
        end
        ]]--
    end
})

function set_player_model_visibility(player,is_visible)
    local name = player:get_player_name()
    models[name].wield_item:set_properties({is_visible = is_visible})
    models[name].model:set_properties({is_visible = is_visible})
end

function set_player_backpack_visibility(player,is_visible)
    local name = player:get_player_name()
    models[name].backpack:set_properties({is_visible = is_visible})
end

function attach_player_backpack_to_hand(player)
    local name = player:get_player_name()
    models[name].backpack:set_attach(models[name].model,"Arm_Right", {x=3,y=4.4,z=0}, {x=90,y=0,z=180}, true)
end

function reattach_player_backpack_to_back(player)
    local name = player:get_player_name()
    models[name].backpack:set_attach(models[name].model,"Body", {x=0,y=5,z=6.1}, {x=0,y=180,z=0}, true)
end

function set_player_backpack_opened(player, opened)
    local name = player:get_player_name()
    models[name].backpack:get_luaentity():set_opened(opened)
end

function get_player_backpack_entity(player)
    local name = player:get_player_name()
    return models[name].backpack
end

minetest.register_on_joinplayer(function(player)
    --removes the 2D green guy
    player:set_properties({
        textures = {"invisible.png"},
    })

    local name = player:get_player_name()

    local model = minetest.add_entity(player:get_pos(), "player_model")
    model:get_luaentity().attached_player = name
    model:set_attach(player,"", {x=0,y=0,z=-1.5}, {x=0,y=0,z=0}, true)

    -- this is an attachment linkage to the player model entity
    local wield_item = minetest.add_entity(player:get_pos(), "player_holding_item")
    wield_item:get_luaentity().attached_player = name
    wield_item:set_attach(model,"Arm_Right", {x=0,y=6,z=1}, {x=90,y=0,z=-90}, true)


    -- this is an attachment linkage to the player model entity
    local secondary_wield_item = minetest.add_entity(player:get_pos(), "player_holding_item_left_hand")
    secondary_wield_item:get_luaentity().attached_player = name
    secondary_wield_item:set_attach(model,"Arm_Left", {x=0,y=6,z=1}, {x=90,y=0,z=-90}, true)

    -- this is another attachment linkage to the player model entity
    local backpack_model = minetest.add_entity(player:get_pos(), "backpack")
    backpack_model:get_luaentity().attached_player = name
    backpack_model:set_attach(model,"Body", {x=0,y=5,z=6.1}, {x=0,y=180,z=0}, true)

    models[name] = {wield_item = wield_item, secondary_wield_item = secondary_wield_item, model = model, backpack = backpack_model}
end)