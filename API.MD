# API information for project undead

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
    
    -- alternatively you can do all_texture, which will automatically assign this texture to all faces
    -- this will override any X_texture defined above, so be careful.
    all_texture = "blah.png",
    
    -- an easier to define node_box, takes into account texture size. See: pixel_box below
    pixel_box = {},
    pixel_box_texture_size = 32,
    translucent = true,
    
    -- directly input a nodebox and it will be digested as so
    pixel_box_specific = {},
    
    -- this allows players to climb over the tile you're creating
    climb_over = true,
    
    -- this will automatically assign the tile to be a solid pole that doesn't connect to anything.
    -- sunlight will also pass through it infinitely.
    pole = true,
    
    -- this is a very easy way to create glass
    glass = true,
    
    pointable = false,
    climbable = true,
    
    --damage per second
    dps = 0,
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
hunger - how hungry you are - higher is more satisfied
thirst - how thirsty you are - higher is more satisfied
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

### hurt_player(player, damage)

This allows mods to hurt the player. Health is held in a float ranging from -0.0 to 100.0. When then player's health reaches 0 or below, it will kill them.

---

### heal_player(player, damage)

This is the inverse of the hit_player() function. Health can never go above 100.0. If it is set to over 100, it will automatically adjust back to 100.

---

### raise_X(player, X_amount)

A generic for stats, health is handled with it's own functions due to the way health needs to be handled internally.

raise_X is defined as in the variable X stands for one of the values defined in get_player_stat. An example:
```
raise_sadness(player,0.5)
```

Which will add 0.5 to the stat of sadness for the specified player.

---

### lower_X(player, X_amount)

A generic for stats, health is handled with it's own functions due to the way health needs to be handled internally.

lower_X is defined as in the variable X stands for one of the values defined in get_player_stat. An example:
```
lower_sadness(player,0.5)
```

Which will reduce the stat of sadness by 0.5 for the specified player.

---

### pixel_box

A pixel box is the easier to define nodebox, which is pixel perfect for the texture you define.
The pixel box uses face direction automatically, so you can easily edit the map and put in more things in editor mode!

You must put in a pixel_box_texture_size and work between the boundaries. This can also be used to define sub-pixel accuracy.

Translucency, is defined with a simple boolean of "translucent".

The definition is very simple:

```
register_tile({
    name = "my_cool_tile",
    all_texture = "my_texture.png",
    
    pixel_box_texture_size = 32,
    pixel_box = {
        {
            15,
            0,
            0,

            17,
            32,
            32
        },
        {
            0,0,0,32,32,32
        },
        -- so on and so forth
    }
    
    translucent = true,
})
```

---

### glass

Creating a glass is very easy. All you must do is add "glass = true" to the definition and it will behave as a solid tile of glass with translucency.

```
register_tile({
    name = "glass",
    all_texture = "glass.png",
    glass = true,
})
```

---

### add_item(pos, item_name)

This is similar to minetest.add_item. The only exception is it adds a new, lighter weight item instead of the built-in item
entity.
