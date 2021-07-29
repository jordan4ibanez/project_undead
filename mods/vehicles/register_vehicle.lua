local register_entity = minetest.register_entity
local insert = table.insert

local vehicle_data = {sport = {}, police = {}, normal = {}}

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


    register_entity(":"..def.name,{
        visual = "mesh",
        mesh = def.mesh,
        textures = {def.texture},
        pointable = false,
        visual_size = {x = def.scale, y = def.scale},
        player_seat_fl = nil,
        player_seat_fr = nil,
        player_seat_rl = nil,
        player_seat_rr = nil,


        on_step = function(self,dtime)

        end,
        on_activate = function(self)

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
    visual_size = {x = 5, y = 5},
    attached_vehicle = nil,
    on_step = function(self,dtime)

    end,

    on_activate = function(self)
        -- automatically discard this model
        --[[
        if (not self.attached_vehicle) then
            self.object:remove()
        end
        ]]--
        -- the lifetime of the model will perpetually be in this animation
        -- only the speed will vary, starts off at 0
        self.object:set_animation({ x = 0, y = 40 }, 20, 0, true)
    end,

    -- allows the car to automatically set the animation speed of the wheels
    set_speed = function(self,speed)
        self.object:set_animation_frame_speed(speed)
    end,
})