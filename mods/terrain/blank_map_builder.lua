local grass = minetest.get_content_id("grass")
local get_mapgen_object = minetest.get_mapgen_object
local vm, emin, emax, area
local data = {}

minetest.register_on_generated(function(minp, maxp)
    if (minp.y == -32) then
        vm, emin, emax = get_mapgen_object("voxelmanip")
        area = VoxelArea:new{MinEdge = emin, MaxEdge = emax}
        vm:get_data(data)

        for x = minp.x, maxp.x do
            for z = minp.z, maxp.z do
                data[area:index(x, 0, z)] = grass
            end
        end
        vm:set_data(data)
        vm:set_lighting({day=15,night=0}, minp, maxp)
        vm:write_to_map()
    end
end)