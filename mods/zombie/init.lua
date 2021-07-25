local walk_start = 168
local walk_end = 188

minetest.register_entity(":zombie",{
    visual = "mesh",
    mesh = "zombie.b3d",
    textures = {"zombie.png"},
    pointable = false,
    visual_size = {x = 1.1, y = 1.1},
    current_animation = 0,

    physical = true,

    collide_with_objects = false,

    collisionbox = {-0.5, 0.0, -0.5, 0.5, 1.5, 0.5},

    on_step = function(self)

    end,

    on_activate = function(self)
        self.object:set_acceleration({x=0,y=-10,z=0})
    end
})