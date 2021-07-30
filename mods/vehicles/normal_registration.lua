-- 4 door sedan
register_vehicle({
    name = "huxton_roadster"
})

--- 4 door sports car
register_vehicle({
    name = "hearken_autobahn",
    info = "Hearken Autobahn 2.2L",
    mesh = "hearken_autobahn.obj",
    texture = "hearken_autobahn.png",
    scale = 27,
    wheel = "normal",
    power = "190",
    class = "sport",

    front_wheel_scale = { x = 4.5, y = 4.5},
    front_track_width = 10,
    front_suspension_height = 5,
    front_wheel_base = 21.95,

    rear_wheel_scale = { x = 4.5, y = 4.5},
    rear_track_width = 10,
    rear_suspension_height = 5,
    rear_wheel_base = 13.6,
})
