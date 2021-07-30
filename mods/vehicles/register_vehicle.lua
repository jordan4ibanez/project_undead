local register_entity = minetest.register_entity
local after = minetest.after
local insert = table.insert
local absolute = math.abs
local yaw_to_dir = minetest.yaw_to_dir
local vector_length = vector.length
local vector_multiply = vector.multiply

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


local function do_control_input(self, dtime)

    local turn_left = false
    local turn_right = false
    local accelerate = false
    local brake = false
    local e_brake = false

    local control_bits = self.driver:get_player_control_bits()

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
        e_brake = true
    end

    -- right
    if (control_bits >= 8) then
        control_bits = control_bits - 8
        turn_right = true
    end

    -- left
    if (control_bits >= 4) then
        control_bits = control_bits - 4
        turn_left = true
    end

    -- down
    if (control_bits >= 2) then
        control_bits = control_bits - 2
        brake = true
    end

    -- up
    if (control_bits >= 1) then
        control_bits = control_bits - 1
        accelerate = true
    end


    -- turn left
    if (turn_left) then
        if (self.steering_angle > -45) then
            self.steering_angle = self.steering_angle - (dtime * 100)
            -- correct for delta overshoot
            if (self.steering_angle < -45) then
                self.steering_angle = -45
            end
        end
    -- turn right
    elseif (turn_right) then
        if (self.steering_angle < 45) then
            self.steering_angle = self.steering_angle + (dtime * 100)
            -- correct for delta overshoot
            if (self.steering_angle > 45) then
                self.steering_angle = 45
            end
        end
    -- return steering to center
    elseif (not turn_left and not turn_right) then
        -- digest delta value
        if (self.steering_angle > 0) then
            self.steering_angle = self.steering_angle - (dtime * 100)
        elseif (self.steering_angle < 0) then
            self.steering_angle = self.steering_angle + (dtime * 100)
        end

        -- finally perfectly center with delta correction
        if (absolute(self.steering_angle) <  (dtime * 100)) then
            self.steering_angle = 0
        end
    end


    -- guide wheel entities
    if (self.fr_wheel and self.fr_wheel:get_luaentity()) then
        local parent,bone,position = self.fr_wheel:get_attach()
        self.fr_wheel:set_attach(parent,bone,position,{ x = 0, y = self.steering_angle, z = 0 })
    end
    if (self.fl_wheel and self.fl_wheel:get_luaentity()) then
        local parent,bone,position = self.fl_wheel:get_attach()
        self.fl_wheel:set_attach(parent,bone,position,{ x = 0, y = self.steering_angle, z = 0 })
    end


    -- reset speed in case car hits something
    if (self.current_speed ~= 0) then
        local current_velocity = self.object:get_velocity()
        local length = vector_length(current_velocity)

        if (length < self.current_speed) then
            self.current_speed = length
        end
    end


    -- car acceleration todo: add in E-Brake functionality
    if (accelerate and not brake and not e_brake) then
        if (self.current_speed < self.max_speed) then
            self.current_speed = self.current_speed + ((dtime * 100) * self.acceleration)

            if (self.current_speed > self.max_speed) then
                self.current_speed = self.max_speed
            end
        end


    -- car brakes
    elseif (not accelerate and brake and not e_brake) then
        if (self.current_speed > self.max_reverse_speed) then
            self.current_speed = self.current_speed - ((dtime * 100) * self.brake_force)

            if (self.current_speed < self.max_reverse_speed) then
                self.current_speed = self.max_reverse_speed
            end
        end
    -- air resistance
    elseif (not accelerate and not brake and not e_brake) then
        if (self.current_speed ~= 0) then
            if (self.current_speed > 0) then
                self.current_speed = self.current_speed - ((dtime * 100) * self.air_resistance)
            elseif (self.current_speed < 0) then
                self.current_speed = self.current_speed + ((dtime * 100) * self.air_resistance)
            end

            if (absolute(self.current_speed) < ((dtime * 100) * self.air_resistance)) then
                self.current_speed = 0
            end
        end
    end

    -- steering
    if (self.steering_angle ~= 0 and self.current_speed ~= 0) then
        local angle_addition = 0
        local yaw = self.object:get_yaw()
        if (self.current_speed > 0) then
            angle_addition = (self.steering_angle/-45) * ((dtime/15) * self.current_speed)
        elseif (self.current_speed < 0) then
            angle_addition = (self.steering_angle/-45) * ((dtime/5) * self.current_speed)
        end

        self.object:set_yaw(yaw + angle_addition)
    end

    -- apply velocity
    self.object:set_velocity(vector_multiply(yaw_to_dir(self.object:get_yaw()), self.current_speed))
end

local function do_no_driver(self,dtime)
    -- air resistance
    if (self.current_speed ~= 0) then
        if (self.current_speed > 0) then
            self.current_speed = self.current_speed - ((dtime * 100) * self.brake_force)
        elseif (self.current_speed < 0) then
            self.current_speed = self.current_speed + ((dtime * 100) * self.brake_force)
        end

        if (absolute(self.current_speed) < ((dtime * 100) * self.brake_force)) then
            self.current_speed = 0
        end
    end
    -- return steering to center
    if (self.steering_angle ~= 0) then
        -- digest delta value
        if (self.steering_angle > 0) then
            self.steering_angle = self.steering_angle - (dtime * 100)
        elseif (self.steering_angle < 0) then
            self.steering_angle = self.steering_angle + (dtime * 100)
        end

        -- finally perfectly center with delta correction
        if (absolute(self.steering_angle) <  (dtime * 100)) then
            self.steering_angle = 0
        end
    end

    -- guide wheel entities
    if (self.fr_wheel and self.fr_wheel:get_luaentity()) then
        local parent,bone,position = self.fr_wheel:get_attach()
        self.fr_wheel:set_attach(parent,bone,position,{ x = 0, y = self.steering_angle, z = 0 })
    end
    if (self.fl_wheel and self.fl_wheel:get_luaentity()) then
        local parent,bone,position = self.fl_wheel:get_attach()
        self.fl_wheel:set_attach(parent,bone,position,{ x = 0, y = self.steering_angle, z = 0 })
    end

    -- apply velocity
    self.object:set_velocity(vector_multiply(yaw_to_dir(self.object:get_yaw()), self.current_speed))
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

    -- allow nil wheel definition
    if (not def.wheel) then
        wheel_type = "normal_wheel"
    elseif (def.wheel == "normal") then
        wheel_type = "normal_wheel"
    end

    -- allow nil vehicle collision data
    def.vehicle_height = def.vehicle_height or 1
    def.vehicle_width = def.vehicle_width or 1
    def.height_offset = def.height_offset or 0

    -- allow nil horsepower
    def.power = def.power or 150

    -- allow nil brake force
    def.brake_force = def.brake_force or 100

    -- allow nil air resistance
    def.air_resistance = def.air_resistance or 200

    -- allow nil wheel animation multiplier
    def.wheel_animation_multiplier = def.wheel_animation_multiplier or 1

    register_entity(":"..def.name,{
        visual = "mesh",
        mesh = def.mesh,
        textures = {def.texture},
        pointable = true,
        visual_size = {x = def.scale, y = def.scale},

        physical = true,
        collide_with_objects = true,
        collisionbox = {-def.vehicle_width, 0.0 + def.height_offset, -def.vehicle_width, def.vehicle_width, def.vehicle_height + def.height_offset, def.vehicle_width},

        player_seat_fl = nil,
        player_seat_fr = nil,
        player_seat_rl = nil,
        player_seat_rr = nil,

        fr_wheel = nil,
        fl_wheel = nil,
        rr_wheel = nil,
        rl_wheel = nil,

        steering_angle = 0,

        driver = nil,

        max_speed = def.max_speed,

        max_reverse_speed = def.max_reverse_speed,

        current_speed = 0,

        acceleration = def.power/1000,

        brake_force = def.brake_force/1000,

        air_resistance = def.air_resistance/1000,

        wheel_animation_multiplier = def.wheel_animation_multiplier,

        on_step = function(self, dtime)
            if (self.driver) then
                do_control_input(self, dtime)
                self.driver:set_look_horizontal(self.object:get_yaw())
            else
                do_no_driver(self,dtime)
            end

            -- control wheel speed animation
            self.fr_wheel:get_luaentity():set_speed(self.current_speed * self.wheel_animation_multiplier)
            self.fl_wheel:get_luaentity():set_speed(self.current_speed * self.wheel_animation_multiplier)
            self.rr_wheel:get_luaentity():set_speed(self.current_speed * self.wheel_animation_multiplier)
            self.rl_wheel:get_luaentity():set_speed(self.current_speed * self.wheel_animation_multiplier)
        end,

        on_rightclick = function(self, clicker)
            if (not self.driver) then
                self.driver = clicker
                clicker:set_attach(self.object, "", { x = 0, y = 0, z = 0 }, { x = 0, y = 0, z = 0 }, false)
                set_player_model_visibility(clicker, false)
                clicker:set_eye_offset({ x = 0, y = -10, z = 0}, { x = 0, y = 20, z = -5 })
            elseif (self.driver == clicker) then
                self.driver = nil
                clicker:set_detach()
                set_player_model_visibility(clicker, true)
                clicker:set_eye_offset({ x = 0, y = 0, z = 0}, { x = 0, y = 0, z = 0 })
            end
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

            self.object:set_acceleration({ x = 0, y = -100, z = 0 })
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