![project undead](https://github.com/jordan4ibanez/project_undead/blob/main/menu/header.png?raw=true "project undead")


 ## A zombie survival game in the Minetest engine

### What the hell is a Minetest engine?

I'm so glad you asked! The Minetest engine, as described on [the website](https://www.minetest.net), is: 

"An open source voxel game engine. Play one of our many games, mod a game to your liking, make your own game, or play on a multiplayer server."

Wow! This sounds like a cheap Minecraft clone! Well it's even better than cheap, it's free. [And you can browse the code here.](https://github.com/minetest/minetest)

Minetest is commonly used to create block based games, ala, [this](https://forum.minetest.net/viewtopic.php?t=16407),
[this](https://forum.minetest.net/viewtopic.php?f=15&t=13700),
[this](https://forum.minetest.net/viewtopic.php?f=15&t=24492),
[this](https://forum.minetest.net/viewtopic.php?f=15&t=9196),
[and this!](https://forum.minetest.net/viewtopic.php?f=15&t=20986) 

What this game is using the engine for is a bit different. Hopefully, you enjoy it.

---

### Editor Mode

There is no editor gui yet, so you'll have to look through the registrations in the terrain mod to get tile names.

You can add this to your minetest.conf if you want to edit the map.

```editor_mode = true```

Alternatively you can just type in this, go to the main menu, then go back into the game to go into editor mode.

```/set editor_mode true```

This is useful for content creators to customize the environment, along with making all new environments for players to
survive in.

---

### Tiles

Tiles are a bit different from what you're most likely used to using the Minetest engine. There are no ``mod:names_seperated_by_colon``.
This is to introduce simplicity and ease of use internally as well as reduce the constant boilerplate code
that is commonly seen in many Minetest games. It also makes modifications working with terrain elements easier to read. 

When doing ``/giveme`` you can simply type in ``/giveme concrete`` for example.

From an API aspect, you can still access the default ``minetest.register_node``, but you'll lose modularity
and integration into the design aspects of the internal game, without research into it, along with a lot of boilerplate.

These are, of course, still nodes, they behave like nodes, but they're functionally different when it comes to content creation.
You can read [API.MD](https://github.com/jordan4ibanez/project_undead/blob/main/API.MD) for more information.

---

### Climbing over things

If you come to an obstacle in the way, say a barrier, sand bag, guard rail, low fence, you could hold space and forwards
to climb over it. You can not climb over everything, so plan your getaway accordingly.

---