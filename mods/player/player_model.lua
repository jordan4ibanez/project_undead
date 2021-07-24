local get_player_by_name = minetest.get_player_by_name

local player = nil
local old_control_bits = 0
local control_bits = 0

local hitting = false
local crouching = false
local moving = false

minetest.register_entity(":player_model",{
    visual = "mesh",
    mesh = "player.b3d",
    textures = {"player.png"},
    pointable = false,
    visual_size = {x = 1.1, y = 1.1},
    attached_player = nil,
    timer = 0,
    on_step = function(self, dtime)
        if (self.attached_player == nil) then
            self.object:remove()
            return
        end

        player = get_player_by_name(self.attached_player)

        if (player == nil) then
            self.object:remove()
            return
        end

        -- a cache happy way to intercept player controls

        crouching = false
        moving = false
        hitting = false
        control_bits = player:get_player_control_bits()
        old_control_bits = control_bits

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


        -- do animation

        if (crouching) then
            print("I am crouching")
        end

        if (moving) then
            print("I am moving")
        end

        if (hitting) then
            print("I am hitting")
        end

    end
})

minetest.register_on_joinplayer(function(player)
    --removes the 2D green guy
    player:set_properties({
        textures = {"invisible.png"},
    })
    local model = minetest.add_entity(player:get_pos(), "player_model")
    model:get_luaentity().attached_player = player:get_player_name()
    model:set_attach(player,"", {x=0,y=0,z=-1.5}, {x=0,y=0,z=0}, true)
end)