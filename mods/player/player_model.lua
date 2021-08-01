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

--[[
    current_animation:
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

            local item = player:get_wielded_item():get_name()

            self.set_item(self,item)
        end

        -- allow player to aim down gun sights
        if (self.gun) then
            local player_aiming = player_is_aiming(get_player_by_name(self.attached_player))
            if (player_aiming and not self.aim_adjusted) then
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

        local holding_gun = get_item_group(player:get_wielded_item():get_name(), "gun") > 0

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

    models[name] = {wield_item = wield_item, model = model}
end)