-- 4 door sedan - police variant
-- taller, faster, more aerodynamic, bigger wheels, better braking
register_vehicle({
    name = "huxton_roadster_police",
    info = "Huxton Roadster Police Interceptor",
    class = "muscle",

    mesh = "huxton_roadster.obj",
    texture = "huxton_roadster_police.png",
    scale = 22,
    wheel = "normal",
    wheel_animation_multiplier = 5,

    -- power, brake, friction = 0 - 1000
    power = 480,
    brake_force = 600,
    air_resistance = 20, -- higher means car slows down faster
    -- do not exceed 80 - outrun map loading
    max_speed = 80,
    max_reverse_speed = -9,

    front_wheel_scale = { x = 4.5, y = 5.2},
    front_track_width = 11,
    front_suspension_height = 10,
    front_wheel_base = 24,

    rear_wheel_scale = { x = 4.5, y = 5.2},
    rear_track_width = 11,
    rear_suspension_height = 10,
    rear_wheel_base = 15.5,

    vehicle_height = 2.175,
    height_offset = -1.5,
    vehicle_width = 1.25,
})