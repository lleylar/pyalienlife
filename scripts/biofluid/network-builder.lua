--rendering.draw_circle{color = {1, 1, 1}, radius = 0.5, filled = true, target = {x, y}, surface = entity.surface}

local PIPE = 1
local ROBOPORT = 2
local PROVIDER = 3
local REQUESTER = 4

Biofluid.connectable = {
	['vessel'] = PIPE,
	--['vessel-to-ground'] = PIPE,
	['bioport'] = ROBOPORT,
	['provider-tank'] = PROVIDER,
	['requester-tank'] = REQUESTER,
}

function Biofluid.heat_connection_facing_offset(entity, connection)
	local direction = (connection.direction + entity.direction) % 8
	if direction == defines.direction.north then
		return {0, -1}
	elseif direction == defines.direction.south then
		return {0, 1}
	elseif direction == defines.direction.east then
		return {1, 0}
	elseif direction == defines.direction.west then
		return {-1, 0}
	end
end

function Biofluid.find_heat_connections(entity)
	local connections = {}
	local buffer = entity.prototype.heat_buffer_prototype or entity.prototype.heat_energy_source_prototype
	if not buffer then return connections end
	local position = entity.position
	local direction = entity.direction
	for _, connection in pairs(buffer.connections) do
		local connection_x = connection.position[1]
		local connection_y = connection.position[2]
		if direction == defines.direction.south then
			connection_y = -connection_y
		elseif direction == defines.direction.east then
			connection_x, connection_y = -connection_y, connection_x
		elseif direction == defines.direction.west then
			connection_x, connection_y = connection_y, connection_x
		end
		local x = math.floor(connection_x + position.x)
		local y = math.floor(connection_y + position.y)
		local offset = Biofluid.heat_connection_facing_offset(entity, connection)
		if offset then connections[#connections+1] = {x = x, y = y, facing_x = x + offset[1], facing_y = y + offset[2]} end
	end
	return connections
end

function Biofluid.find_nearby_pipes(entity, connections)
	local force_index = entity.force_index
	local nearby_pipes = {}
	local network_ids = {}
	local network_positions = global.network_positions

	for _, connection in pairs(connections) do
		local facing_x, facing_y = connection.facing_x, connection.facing_y
		local x, y = connection.x, connection.y

		if not network_positions[facing_x] then goto continue end
		local network_data = network_positions[facing_x][facing_y]
		if not network_data then goto continue end
		local is_looking_at_us = false
		for _, facing in pairs(network_data.facing) do
			if facing[1] == x and facing[2] == y then
				is_looking_at_us = true
				break
			end
		end
		if not is_looking_at_us then goto continue end
		local other_pipe = network_data.entity
		if not other_pipe then goto continue end
		if not other_pipe.valid then
			network_positions[facing_x][facing_y] = nil
			if not next(network_positions[facing_x]) then network_positions[facing_x] = nil end
			goto continue
		end
		if other_pipe.force_index ~= force_index then goto continue end
		game.print(entity.name .. entity.unit_number .. '<->' .. other_pipe.name .. other_pipe.unit_number)
		nearby_pipes[#nearby_pipes+1] = network_data
		network_ids[network_data.network_id] = true
		::continue::
	end

	return nearby_pipes, network_ids
end

-- CONSTRUCTIVE
function Biofluid.built_pipe(entity)
	local connections = Biofluid.find_heat_connections(entity)
	if #connections == 0 then return end
	local network_positions = global.network_positions

	for _, connection in pairs(connections) do
		local facing_x, facing_y = connection.facing_x, connection.facing_y
		local x, y = connection.x, connection.y

		if not network_positions[x] then network_positions[x] = {} end
		if not network_positions[x][y] or network_positions[x][y].entity ~= entity then
			network_positions[x][y] = {
				entity = entity,
				facing = {{facing_x, facing_y}}
			}
		else
			table.insert(network_positions[x][y].facing, {facing_x, facing_y})
		end
	end

	local nearby_pipes, network_ids = Biofluid.find_nearby_pipes(entity, connections)
	local network_id
	if #nearby_pipes == 0 then
		network_id = Biofluid.create_network(entity)
	else
		for k, _ in pairs(network_ids) do
			if not network_id then
				network_id = k
			else
				Biofluid.join_networks(network_id, k)
			end
		end
	end

	Biofluid.add_to_network(network_id, entity, connections)
end

function Biofluid.join_networks(new_id, old_id)
	local new = global.biofluid_networks[new_id]
	local old = global.biofluid_networks[old_id]
	if new.force_index ~= old.force_index then
		game.print('ERROR: Attempt to join two biofluid networks with diffrent forces. ' .. new_id .. ' ' .. old_id)
		return
	end
	game.print('joining networks ' .. new_id .. ' ' .. old_id)
	local network_positions = global.network_positions
	for x, column in pairs(old.positions) do
		for y, _ in pairs(column) do
			network_positions[x][y].network_id = new_id
			if not new.positions[x] then new.positions[x] = {} end
			new.positions[x][y] = true
		end
	end
	for k, entity in pairs(old.bioports) do new.bioports[k] = entity end
	for k, entity in pairs(old.requesters) do new.requesters[k] = entity end
	for k, entity in pairs(old.providers) do new.providers[k] = entity end
	global.biofluid_networks[old_id] = nil
end

function Biofluid.create_network(entity)
	local network_id = #global.biofluid_networks + 1
	local network = {
		force_index = entity.force_index,
		network_id = network_id,
		bioports = {},
		requesters = {},
		providers = {},
		positions = {},
	}
	global.biofluid_networks[network_id] = network
	game.print('new network '..network_id)
	return network_id
end

function Biofluid.add_to_network(network_id, entity, connections)
	local network = global.biofluid_networks[network_id]
	local network_positions = global.network_positions
	if not network then
		game.print('ERROR: Invalid biofluid network with ID ' .. network_id)
		return
	end

	for _, connection in pairs(connections) do
		local x, y = connection.x, connection.y
		network_positions[x][y].network_id = network_id
		if not network.positions[x] then network.positions[x] = {} end
		network.positions[x][y] = true
	end

	game.print('added to network ' .. network_id)
	local entity_type = Biofluid.connectable[entity.name]
	if entity_type == PIPE then return end
	local unit_number = entity.unit_number
	if entity_type == ROBOPORT then
		network.bioports[unit_number] = entity
	elseif entity_type == REQUESTER then
		network.requesters[unit_number] = entity
	elseif entity_type == PROVIDER then
		network.providers[unit_number] = entity
	end
end

-- DESTRUCTIVE
function Biofluid.destroyed_pipe(entity)
	local connections = Biofluid.find_heat_connections(entity)
	if #connections == 0 then return end
	local network_positions = global.network_positions
	local network_id

	for _, connection in pairs(connections) do
		local x, y = connection.x, connection.y
		if network_positions[x] and network_positions[x][y] then
			network_id = network_positions[x][y].network_id
			network_positions[x][y] = nil
			if not next(network_positions[x]) then
				network_positions[x] = nil
			end
		end
	end

	if not network_id then return end
	Biofluid.remove_from_network(network_id, entity, connections)

	local nearby_pipes = Biofluid.find_nearby_pipes(entity, connections)
	if #nearby_pipes == 0 then
		Biofluid.delete_network(network_id)
	elseif #nearby_pipes > 1 then
		Biofluid.split_network(network_id)
	end
end

function Biofluid.split_network(network_id)

end

function Biofluid.delete_network(network_id)
	global.biofluid_networks[network_id] = nil
	game.print('deleted network '..network_id)
end

function Biofluid.remove_from_network(network_id, entity, connections)
	local network = global.biofluid_networks[network_id]
	local network_positions = global.network_positions
	if not network then
		game.print('ERROR: Invalid biofluid network with ID ' .. network_id)
		return
	end

	for _, connection in pairs(connections) do
		local x, y = connection.x, connection.y
		if network_positions[x] then network_positions[x][y] = nil end
		if network.positions[x] then network.positions[x][y] = nil end
	end

	game.print('removed from network ' .. network_id)
	local entity_type = Biofluid.connectable[entity.name]
	if entity_type == PIPE then return end
	local unit_number = entity.unit_number
	network.bioports[unit_number] = entity
	network.requesters[unit_number] = entity
	network.providers[unit_number] = entity
end

-- MIXED
function Biofluid.rotated_pipe(entity)
	Biofluid.destroyed_pipe(entity)
	Biofluid.built_pipe(entity)
end