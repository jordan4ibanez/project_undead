local register_entity = minetest.register_entity
local after = minetest.after
local insert = table.insert

local vehicle_data = {sport = {}, police = {}, normal = {}}

local drivers = {}

local function spawn_wheel(vehicle, pos, wheel_type, vehicle_scale, wheel_width, wheel_height, track_width, suspension_height, wheel_base)
    local wheel = minetest.add_entity(pos, wheel_type)
    if (wheel) then
        wheel:get_luaentity().attached_vehicle = vehicle
        wheel:set_properties({visual_size = {x = (1/vehicle_scale) * wheel_width, y = (1/vehicle_scale) * wheel_height, z = (1/vehicle_scale) * wheel_height}})
        wheel:set_attach(vehicle, "", { x = (1/vehicle_scale) * track_width, y = (1/vehicle_scale) * -suspension_height, z = (1/vehicle_scale) * wheel_base }, { x = 0, y = 0, z = 0 }, false)
    end
    return wheel
end


local function debug_steering(self, dtime)
    if (not self.steering_up) then
        self.steering_angle = self.steering_angle - (dtime * 100)
    else
        self.steering_angle = self.steering_angle + (dtime * 100)
    end

    if (self.steering_angle <= -45 or self.steering_angle >= 45) then
        self.steering_up = not self.steering_up
    end


    if (self.fr_wheel and self.fr_wheel:get_luaentity()) then
        local parent,bone,position = self.fr_wheel:get_attach()
        self.fr_wheel:set_attach(parent,bone,position,{ x = 0, y = self.steering_angle, z = 0 })
    end

    if (self.fl_wheel and self.fl_wheel:get_luaentity()) then
        local parent,bone,position = self.fl_wheel:get_attach()
        self.fl_wheel:set_attach(parent,bone,position,{ x = 0, y = self.steering_angle, z = 0 })
    end

    print(self.steering_angle)
end


function register_vehicle(def)
    -- allow nil value
    def.scale = def.scale or 1

    -- allow nil wheel sizes
    def.front_wheel_scale = def.front_wheel_scale or { x = 1, y = 1}
    def.rear_wheel_scale = def.rear_wheel_scale or { x = 1, y = 1}

    -- allow nil wheel track widths
    def.front_track_width = def.front_track_width or 1
    def.rear_track_width = def.rear_track_width or 1

    -- allow nil wheel bases
    def.front_wheel_base = def.front_wheel_base or 1
    def.rear_wheel_base = def.rear_wheel_base or 1

    -- allow nil suspension heights
    def.front_suspension_height = def.front_suspension_height or 1
    def.rear_suspension_height = def.rear_suspension_height or 1

    local wheel_type

    if (def.wheel == "normal") then
        wheel_type = "normal_wheel"
    end

    register_entity(":"..def.name,{
        visual = "mesh",
        mesh = def.mesh,
        textures = {def.texture},
        pointable = editor_mode or false,
        visual_size = {x = def.scale, y = def.scale},

        player_seat_fl = nil,
        player_seat_fr = nil,
        player_seat_rl = nil,
        player_seat_rr = nil,

        fr_wheel = nil,
        fl_wheel = nil,
        rr_wheel = nil,
        rl_wheel = nil,

        steering_angle = 0,
        steering_up = false,

        on_step = function(self, dtime)
            debug_steering(self, dtime)

            self.object:set_yaw(self.object:get_yaw() + (dtime * 0.5))
        end,

        on_activate = function(self)
            local pos = self.object:get_pos()
            -- front right wheel
            self.fr_wheel = spawn_wheel(self.object, pos, wheel_type, def.scale, def.front_wheel_scale.x, def.front_wheel_scale.y, def.front_track_width, def.front_suspension_height, def.front_wheel_base)
            -- front left wheel
            self.fl_wheel = spawn_wheel(self.object, pos, wheel_type, def.scale, def.front_wheel_scale.x, def.front_wheel_scale.y, -def.front_track_width, def.front_suspension_height, def.front_wheel_base)
            -- rear right wheel
            self.rr_wheel = spawn_wheel(self.object, pos, wheel_type, def.scale, def.rear_wheel_scale.x, def.rear_wheel_scale.y, def.rear_track_width, def.rear_suspension_height, -def.rear_wheel_base)
            -- rear left wheel
            self.rl_wheel = spawn_wheel(self.object, pos, wheel_type, def.scale, def.rear_wheel_scale.x, def.rear_wheel_scale.y, -def.rear_track_width, def.rear_suspension_height, -def.rear_wheel_base)
        end
    })

    -- add vehicle data into vehicle_data table
    if (def.class) then
        -- account for custom mod class
        if (not vehicle_data[def.class]) then
            vehicle_data[def.class] = {}
        end
        insert(vehicle_data[def.class], def.name)
    end
end


register_entity(":normal_wheel",{
    visual = "mesh",
    mesh = "wheel.b3d",
    textures = {"wheel.png"},
    pointable = false,
    -- this value is overridden regardless
    visual_size = {x = 1, y = 1, z = 1},
    attached_vehicle = nil,
    on_step = function(self,dtime)

    end,

    on_activate = function(self)
        -- a hack due to order of operations in entity processing being, interesting
        after(0, function()
            -- automatically discard this model
            if (not self.attached_vehicle) then
                self.object:remove()
            end
            -- the lifetime of the model will perpetually be in this animation
            -- only the speed will vary, starts off at 0
            self.object:set_animation({ x = 0, y = 40 }, 30, 0, true)
        end)
    end,

    -- allows the car to automatically set the animation speed of the wheels
    set_speed = function(self,speed)
        self.object:set_animation_frame_speed(speed)
    end,
})