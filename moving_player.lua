get_flowing_dir = function(pos)
	local param2 = minetest.get_node(pos).param2
	for i,d in ipairs({-1, 1, -1, 1}) do
		if i<3 then
			pos.x = pos.x+d
		else
			pos.z = pos.z+d
		end
		
		local name = minetest.get_node(pos).name
		local par2 = minetest.get_node(pos).param2
		if name:match(".*water_flowing") and par2 < param2 then
			return pos
		end
		
		if i<3 then
			pos.x = pos.x-d
		else
			pos.z = pos.z-d
		end
	end
end

minetest.register_globalstep(function(dtime)
	local players = minetest.get_connected_players()
	for _, player in ipairs(players) do
		local p = player:get_pos()
		for i = 0, 15 do
			local node = minetest.get_node(vector.add(p, {x = 0, y = i, z = 0}))
			if minetest.registered_nodes[node.name].liquidtype == "flowing" then
				local vec = get_flowing_dir(vector.add(p, {x = 0, y = i, z = 0}))
				local v = player:get_velocity()
				if vec and vec.x-p.x > 0 then
					player:add_velocity({x = 2, y = 0, z = 0})
				elseif vec and vec.x-p.x < 0 then
					player:add_velocity({x = -2, y = 0, z = 0})
				elseif vec and vec.z-p.z > 0 then
					player:add_velocity({x = 0, y = 0, z = 2})
				elseif vec and vec.z-p.z < 0 then
					player:add_velocity({x = 0, y = 0, z = 2})
				end
				player:add_velocity({x = 0, y = -1, z = 0})
			end
		end
	end
end)
