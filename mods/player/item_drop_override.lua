local getn = table.getn
--[[
modular item_drop overrides which frees up the Q key
the only real problem with this: if a bunch of mods use this, it might lag
]]--

local function_tables = {}

minetest.item_drop = function(itemstack, player, pos)
    for _,func in pairs(function_tables) do
        func(itemstack, player, pos)
    end
    return(nil)
end

function allocate_drop_button(func)
    function_tables[getn(function_tables) + 1] = func
end

-- these are debugging functions, used to verify the api element, also a good source for how to use it
--[[
allocate_drop_button(
        function(itemstack,player,pos)
            print("wow this works")
        end
)


allocate_drop_button(
        function(itemstack,player,pos)
            print("Why is the minetest api written like this?")
        end
)

allocate_drop_button(
        function(itemstack,player,pos)
            print("this is a horrible workaround")
        end
)
]]--