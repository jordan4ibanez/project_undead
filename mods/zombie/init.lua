local get_connected_players = minetest.get_connected_players
local dir_to_yaw = minetest.dir_to_yaw
local yaw_to_dir = minetest.yaw_to_dir
local vector_distance = vector.distance
local vector_direction = vector.direction
local vector_multiply = vector.multiply
local random = math.random
local pi = math.pi
local double_pi = pi * 2

local stand_start = 0
local stand_end = 80

local walk_start = 168
local walk_end = 188

local attack_start = 189
local attack_end = 199

local attack_walk_start = 200
local attack_walk_end = 220

local wander_start = 221
local wander_end = 241

local pos
local pos2
local target_distance

local behavior_selection

local function search_for_player(self)
    pos = self.object:get_pos()
    pos.y = 0

    -- the zombie will keep walking this way regardless
    -- a constant reset
    self.current_target_distance = 100

    for _,player in pairs(get_connected_players()) do
        pos2 = player:get_pos()
        pos2.y = 0

        target_distance = vector_distance(pos, pos2)
        -- 20 tiles away
        if (target_distance <= 20 and target_distance < self.current_target_distance) then
            --give chase
            self.current_target_distance = target_distance
            self.object:set_yaw(dir_to_yaw(vector_direction(pos,pos2)))

            self.behavior = 1 -- chase behavior
            self.chase_cooldown = 20 -- seconds
        end
    end
end

local function handle_animation(self)
    if (self.current_animation ~= 0 and self.behavior == 0) then
        self.object:set_animation({ x = stand_start, y = stand_end }, 20, 0, true)
        self.current_animation = 0
    elseif (self.current_animation ~= 1 and self.behavior == 1) then
        self.object:set_animation({ x = walk_start, y = walk_end }, 20, 0, true)
        self.current_animation = 1
    elseif (self.current_animation ~= 2 and self.behavior == 2) then
        self.object:set_animation({ x = wander_start, y = wander_end }, 20, 0, true)
        self.current_animation = 2
    end
end

local function cycle_random_behavior(self)
    behavior_selection = random(0,1)
    if (behavior_selection == 1) then
        behavior_selection = 2
    end
    self.behavior = behavior_selection
    self.wander_timer = random(5,10)
    self.object:set_yaw(random() * double_pi)
end


local function handle_locomotion(self)
    if (self.behavior == 0) then
        self.object:set_velocity({ x = 0, y = 0, z = 0})
    elseif (self.behavior == 1) then
        self.object:set_velocity(vector_multiply(yaw_to_dir(self.object:get_yaw()), 2))
    elseif (self.behavior == 2) then
        self.object:set_velocity(vector_multiply(yaw_to_dir(self.object:get_yaw()), 1.5))
    end
end

minetest.register_entity(":zombie",{
    zombie = true,
    visual = "mesh",
    mesh = "zombie.b3d",
    textures = {"zombie.png"},
    pointable = false,
    visual_size = {x = 1.1, y = 1.1},
    physical = true,
    collide_with_objects = true,
    collisionbox = {-0.2, 0.0, -0.2, 0.2, 1.5, 0.2},
    internal_timer = 0,
    current_target_distance = 100,
    current_animation = 0,
    behavior = 0, -- 0 stand, 1 chase, 2 wander
    chase_cooldown = 0,
    wander_timer = 0,
    on_step = function(self, dtime)
        self.internal_timer = self.internal_timer + dtime

        -- give a constant chase
        if (self.current_target_distance ~= 100) then
            self.internal_timer = 0.5
        end

        -- only done every half second to preserve resources
        -- is overridden and done every server step if chasing
        if (self.internal_timer >= 0.5) then
            self.internal_timer = 0
            search_for_player(self)
        end

        -- if just randomly walking or standing around
        if (self.behavior == 0 or self.behavior == 2) then
            self.wander_timer = self.wander_timer - dtime
            if (self.wander_timer <= 0) then
                cycle_random_behavior(self)
            end
            -- if chasing a player
        elseif (self.behavior == 1 and self.current_target_distance == 100) then
            self.chase_cooldown = self.chase_cooldown - dtime
            if (self.chase_cooldown <= 0) then
                self.chase_cooldown = 0
                cycle_random_behavior(self)
            end
        end

        handle_locomotion(self)
        handle_animation(self)
    end,

    on_activate = function(self)
        self.object:set_acceleration({ x = 0, y = -10, z = 0 })
        self.object:set_animation({ x = stand_start, y = stand_end }, 20, 0, true)
        self.current_animation = 0
    end
})