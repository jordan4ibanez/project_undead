## API information for project undead

---
### register_tile 
This is a wrapper for minetest.register node, which makes it simpler to add nodes, now called tiles, into the game.

Any tile texture definitions left out will be defined with "invisible.png" to ease up the hardware rendering/engine processing.

This also frees up the need to constantly define "mod:thething", where as now you can just do "thething" and it is handled.

```
register_tile(
    name = "my_amazing_tile",
    top_texture = "blah.png",
    bottom_texture = "blah.png",
    front_texture = "blah.png",
    back_texture = "blah.png",
    right_texture = "blah.png",
    left_texture = "blah.png",
    
    pointable = false,
    climbable = true,
    dps = 0, --damage per second
    waving = true,
)
```

---
### register_item

This is a wrapper for minetest.register_craftitem.

The main benefit for wrapping this, is that since the player has a 3D model, individual items no longer need constant looking after
to make sure that they have an invisible wield texture.

This also makes custom mechanics much more viable in the long run. Like before, this also frees up fully qualifying mod names.

```
register_item({
    name = "this_item",
    description = "This is here to show you how to do things",
    groups = {floofy = true, glarp = -22, hanging = "woof"},
    inventory_image = "this_is_what_will_show_up_in_inventories.png",
})
```

---

### get_player_stat(player_name, field)

This returns a specific stat from the player. There are 9 stats, and they are:
```
health - how healthy you are
hunger - how hungry you are
thirst - how thirsty you are
exhaustion - can limit your speed/stamina
panic - how panicked you are, can cause you to miss swings and not be able to sleep
infection - once bit, this will start climbing
sadness - can cause a bunch of issues
strength - how much you can carry, how hard you can swing
fitness - how fast you can run and for how long
```

This will always return a float value.

---

### get_player_stat_table(player_name)

This is similar to get_player_stat, only it will return the raw table of the stats, which you can modify and work with.

---

### set_player_stat(player_name, field, new_value)

The inverse of get_player_stat. With this, mods can actively modify the player's stats in real time.

---