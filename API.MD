## API information for project undead

### register_tile 
This is a wrapper for minetest.register node, which makes it simpler to add nodes, now called tiles, into the game.

Any tile texture definitions left out will be defined with "invisible.png" to ease up the hardware rendering/engine processing.
```
register_tile(
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
