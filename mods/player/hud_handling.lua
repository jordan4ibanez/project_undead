
local stat_intake

--hud hierarchy = hud - player - hud element

local hud = {}



function run_initial_hud_creation(player)
    --basically turn everything off
    player:hud_set_flags({crosshair = false, wielditem = false, hotbar = false, healthbar = false, breathbar = false, minimap = true, minimap_radar = false})

    local name = player:get_player_name()
    hud[name] = {}


    stat_intake = get_player_stat_table(player:get_player_name())

    player:hud_add({
        hud_elem_type = "image",
        position  = {x = -0.028, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "stat_bg.png",
        scale     = { x = -7, y = -10},
        alignment = { x = 1, y = -1 },
        z_scale = -1,
    })

    hud[name].health = player:hud_add({
        hud_elem_type = "image",
        position  = {x = -0.028, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "health.png",
        scale     = { x = -7, y = (stat_intake.health / 100) *  -10},
        alignment = { x = 1, y = -1 },
    })



    player:hud_add({
        hud_elem_type = "image",
        position  = {x = -0.016, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "stat_bg.png",
        scale     = { x = -7, y = -10},
        alignment = { x = 1, y = -1 },
        z_scale = -1,
    })

    hud[name].hunger = player:hud_add({
        hud_elem_type = "image",
        position  = {x = -0.016, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "hunger.png",
        scale     = { x = -7, y = (stat_intake.hunger / 100) * -10},
        alignment = { x = 1, y = -1 },
    })



    player:hud_add({
        hud_elem_type = "image",
        position  = {x = -0.004, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "stat_bg.png",
        scale     = { x = -7, y = -10},
        alignment = { x = 1, y = -1 },
        z_scale = -1,
    })

    hud[name].thirst = player:hud_add({
        hud_elem_type = "image",
        position  = {x = -0.004, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "thirst.png",
        scale     = { x = -7, y = (stat_intake.thirst / 100) * -10},
        alignment = { x = 1, y = -1 },
    })



    player:hud_add({
        hud_elem_type = "image",
        position  = {x = 0.008, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "stat_bg.png",
        scale     = { x = -7, y = -10},
        alignment = { x = 1, y = -1 },
        z_scale = -1,
    })

    hud[name].exhaustion = player:hud_add({
        hud_elem_type = "image",
        position  = {x = 0.008, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "exhaustion.png",
        scale     = { x = -7, y = (stat_intake.exhaustion / 100) * -10},
        alignment = { x = 1, y = -1 },
    })


    player:hud_add({
        hud_elem_type = "image",
        position  = {x = 0.02, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "stat_bg.png",
        scale     = { x = -7, y = -10},
        alignment = { x = 1, y = -1 },
        z_scale = -1,
    })

    hud[name].panic = player:hud_add({
        hud_elem_type = "image",
        position  = {x = 0.02, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "panic.png",
        scale     = { x = -7, y = (stat_intake.panic / 100) * -10},
        alignment = { x = 1, y = -1 },
    })


    player:hud_add({
        hud_elem_type = "image",
        position  = {x = 0.032, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "stat_bg.png",
        scale     = { x = -7, y = -10},
        alignment = { x = 1, y = -1 },
        z_scale = -1,
    })

    hud[name].infection = player:hud_add({
        hud_elem_type = "image",
        position  = {x = 0.032, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "infection.png",
        scale     = { x = -7, y = (stat_intake.infection / 100) * -10},
        alignment = { x = 1, y = -1 },
    })


    player:hud_add({
        hud_elem_type = "image",
        position  = {x = 0.044, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "stat_bg.png",
        scale     = { x = -7, y = -10},
        alignment = { x = 1, y = -1 },
        z_scale = -1,
    })

    hud[name].sadness = player:hud_add({
        hud_elem_type = "image",
        position  = {x = 0.044, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "sadness.png",
        scale     = { x = -7, y = (stat_intake.sadness / 100) * -10},
        alignment = { x = 1, y = -1 },
    })


    player:hud_add({
        hud_elem_type = "image",
        position  = {x = 0.056, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "stat_bg.png",
        scale     = { x = -7, y = -10},
        alignment = { x = 1, y = -1 },
        z_scale = -1,
    })

    hud[name].strength = player:hud_add({
        hud_elem_type = "image",
        position  = {x = 0.056, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "strength.png",
        scale     = { x = -7, y = (stat_intake.strength / 100) * -10},
        alignment = { x = 1, y = -1 },
    })


    player:hud_add({
        hud_elem_type = "image",
        position  = {x = 0.068, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "stat_bg.png",
        scale     = { x = -7, y = -10},
        alignment = { x = 1, y = -1 },
        z_scale = -1,
    })

    hud[name].fitness = player:hud_add({
        hud_elem_type = "image",
        position  = {x = 0.068, y = 0.105},
        offset    = {x = 0, y = 0},
        text      = "fitness.png",
        scale     = { x = -7, y = (stat_intake.fitness / 100) * -10},
        alignment = { x = 1, y = -1 },
    })
end

function update_stat(player_name, stat_string, new_value)
    hud[player_name][stat_string] = new_value
end