-- 4 door sedan
register_vehicle({
    name = "huxton_roadster",
    info = "Huxton Roadster",
    class = "normal",

    mesh = "huxton_roadster.obj",
    texture = "huxton_roadster_bronze.png",
    scale = 26,
    wheel = "normal",
    wheel_animation_multiplier = 5,

    -- power, brake, friction = 0 - 1000
    power = 250,
    brake_force = 300,
    air_resistance = 60, -- higher means car slows down faster
    -- do not exceed 80 - outrun map loading
    max_speed = 50,
    max_reverse_speed = -6,

    front_wheel_scale = { x = 5, y = 6},
    front_track_width = 13,
    front_suspension_height = 10.5,
    front_wheel_base = 28,

    rear_wheel_scale = { x = 5, y = 6},
    rear_track_width = 13,
    rear_suspension_height = 10.5,
    rear_wheel_base = 18.5,

    vehicle_height = 2.3,
    height_offset = -1.65,
    vehicle_width = 1.4,
})

-- 4 door sports car
register_vehicle({
    name = "hearken_autobahn",
    info = "Hearken Autobahn 2.2L",
    class = "sport",

    mesh = "hearken_autobahn.obj",
    texture = "hearken_autobahn.png",
    scale = 27,
    wheel = "normal",
    wheel_animation_multiplier = 5,

    -- power, brake, friction = 0 - 1000
    power = 190,
    brake_force = 300,
    air_resistance = 40, -- higher means car slows down faster
    -- do not exceed 80 - outrun map loading
    max_speed = 50,
    max_reverse_speed = -5,

    front_wheel_scale = { x = 4.5, y = 4.5},
    front_track_width = 10,
    front_suspension_height = 5,
    front_wheel_base = 21.95,

    rear_wheel_scale = { x = 4.5, y = 4.5},
    rear_track_width = 10,
    rear_suspension_height = 5,
    rear_wheel_base = 13.6,

    vehicle_height = 1.95,
    height_offset = -0.9,
    vehicle_width = 0.9,
})
