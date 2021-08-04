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
[and this!](https://forum.minetest.net/viewtopic.php?f=15&t=20986) (Links work if the forum isn't down!)

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

### API

Minetest's engine has a built-in API. An Application Programming Interface. This is a bit of a misnomer as every game written
using the default Minetest game engine needs to utilize this. The engine has no internal built in game.

Project Undead has an API built on top of this API. "Man that sounds like a waste of time!", you are probably saying to yourself.
This would be the case, if not for the special use-case that this project is utilizing the Minetest engine for. Where, most games
in the Minetest engine, in fact, most mods in general, are expecting a procedurally generated environment. Environments with
extensive unknown variables, heights, terrain, unknown interactions, mod conflicts, etc. In this game, it gets a lot easier for
developers. 

This game has an extreme advantage over the normal use-case. All variables, besides entities, are known. The terrain takes 
a lot of effort to modify. Players are more focused on trying to survive vs exploiting the major mechanics and design flaws 
of interoperating mods which require extensive boilerplate code to interfere with each other properly. Players are also instantly 
kicked from the game if they utilize cheat clients to dig tiles.

In Project Undead there are set variables that are designed to be as congruent as physically possible based on the limitations
and strengths programmed into the Minetest engine. There are custom assets, mechanics, design choices that have never been implemented
into any Minetest game in such a manor before. This allows the design of the engine to skip huge chunks of the internal Minetest
API, allowing developers to roll out mods in a clean and simple manor.

There are many custom functions and mechanics built into project undead. If you would like to take a look at the current API, 
feel free to look through [API.MD](https://github.com/jordan4ibanez/project_undead/blob/main/API.MD) This may be outdated 
slightly, as this is programmed and documented by one developer as it's created. 