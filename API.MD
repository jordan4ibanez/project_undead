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
