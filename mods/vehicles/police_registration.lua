-- 4 door sedan - police variant
-- taller, faster, more aerodynamic, better braking
register_vehicle({
    name = "huxton_roadster_police",
    info = "Huxton Roadster Police Interceptor",
    class = "normal",

    mesh = "huxton_roadster.obj",
    texture = "huxton_roadster_police.png",
    scale = 26,
    wheel = "normal",
    wheel_animation_multiplier = 5,

    -- power, brake, friction = 0 - 1000
    power = 480,
    brake_force = 600,
    air_resistance = 20, -- higher means car slows down faster
    -- do not exceed 80 - outrun map loading
    max_speed = 80,
    max_reverse_speed = -9,

    front_wheel_scale = { x = 5, y = 6},
    front_track_width = 13,
    front_suspension_height = 11.8,
    front_wheel_base = 28,

    rear_wheel_scale = { x = 5, y = 6},
    rear_track_width = 13,
    rear_suspension_height = 11.8,
    rear_wheel_base = 18.5,

    vehicle_height = 2.3,
    height_offset = -1.75,
    vehicle_width = 1.4,
})