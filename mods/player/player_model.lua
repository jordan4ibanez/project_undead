local get_player_by_name = minetest.get_player_by_name

minetest.register_entity(":player_model",{
    visual = "mesh",
    mesh = "player.b3d",
    textures = {"player.png"},
    pointable = false,
    visual_size = {x = 1.1, y = 1.1},
    attached_player = nil,
    timer = 0,
    on_step = function(self, dtime)
        self.timer = self.timer + dtime
        if (self.timer >= 0.5) then
            self.timer = 0
            if (self.attached_player == nil or get_player_by_name(self.attached_player) == nil) then
                self.object:remove()
                return
            end
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