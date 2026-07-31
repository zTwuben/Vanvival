local Vanvival_VehicleSpawnHelper = {}

function Vanvival_VehicleSpawnHelper.sayLater(player, msg, delayTicks)
    local ticks = delayTicks or 100

    local function delayedSay()
        ticks = ticks - 1
        if ticks <= 0 then
            player:Say(msg)
            Events.OnTick.Remove(delayedSay)
        end
    end

    Events.OnTick.Add(delayedSay)
end


function Vanvival_VehicleSpawnHelper.findBuildingNearSquare(square)
    local cell = getCell()
    for dx = -5,5 do
        for dy = -5,5 do
            local sq = cell:getGridSquare(square:getX() + dx, square:getY() + dy, square:getZ())
            if sq then
                local b = sq:getBuilding()
                if b then
                    return b
                end
            end
        end
    end
    return nil
end


function Vanvival_VehicleSpawnHelper.chooseVehicleDirection(square, maxCheckDistance)
	maxCheckDistance = maxCheckDistance or 10
	local building = square:getBuilding() or Vanvival_VehicleSpawnHelper.findBuildingNearSquare(square)

	local directions = {
        {name = "N", dx = 0, dy = -1, enum = IsoDirections.N},
        {name = "S", dx = 0, dy = 1, enum = IsoDirections.S},
        {name = "E", dx = 1, dy = 0, enum = IsoDirections.E},
        {name = "W", dx = -1, dy = 0, enum = IsoDirections.W},
    }

	local bestDir = directions[1]
	local maxFree = -1
	

	if not building then
		bestDir.enum = IsoDirections.E
		return bestDir.enum
	else
		for _, dir in ipairs(directions) do
			local freeCount = 0
			for i = 1, maxCheckDistance do
				local checkX = square:getX() + dir.dx * i
				local checkY = square:getY() + dir.dy * i
				local checkSquare = getCell():getGridSquare(checkX, checkY, square:getZ())
				if checkSquare and checkSquare:isOutside() and checkSquare:isFree(false) and not checkSquare:isVehicleIntersecting() then
					freeCount = freeCount + 1
				else
					break  -- stop counting in this direction
				end
			end

			if freeCount > maxFree then
				maxFree = freeCount
				bestDir = dir
			end
		end
    	return bestDir.enum
	end
end


function Vanvival_VehicleSpawnHelper.getVehicleSpawnNearPlayer(player)

    local square = player:getCurrentSquare()
	if not square then return end

    local building = square:getBuilding() or Vanvival_VehicleSpawnHelper.findBuildingNearSquare(square)

    local world = getWorld()
    if not world then
        return square
    end

    local metaGrid = world:getMetaGrid()
    if not metaGrid then
        return square
    end


    local vehicleSquares = {}
    local z = player:getZ()

    local radius = 20
    local minDistance = 5  -- minimum distance from player spawn


	if not building then
		local playersquare = player:getCurrentSquare()
		if not playersquare then return end
		local sq = getCell():getGridSquare(playersquare:getX(), playersquare:getY() - 2, playersquare:getZ())
		return sq
	else
		---Fallbacks to new car location
		for dx = -radius, radius do
			for dy = -radius, radius do
				local x, y = square:getX() + dx, square:getY() + dy
				local zone = metaGrid:getVehicleZoneAt(x, y, z)
				if zone then
					local sq = getCell():getGridSquare(x, y, z)
					if sq and sq:isOutside() and sq:isFree(false) and not sq:isVehicleIntersecting() then
						local dist = math.sqrt((sq:getX() - square:getX())^2 + (sq:getY() - square:getY())^2)
						if dist >= minDistance then
							table.insert(vehicleSquares, sq)
							print("Valid vehicle zone at:", x, y, z, "dist from player:", dist)
						else
							print("Skipping zone too close to player:", x, y, z, "dist:", dist)
						end
					else
						print("Grid square at", x, y, z, "is nil or not outside")
					end
				end
			end
		end
			if #vehicleSquares > 0 then
				local closestSq = vehicleSquares[1]
				local minDist = math.huge
				local px, py = square:getX(), square:getY()

				for _, vsq in ipairs(vehicleSquares) do
					local dist = (vsq:getX() - px)^2 + (vsq:getY() - py)^2
					if dist < minDist then
						minDist = dist
						closestSq = vsq
					end
				end

				print("Chosen vehicle spawn square:", closestSq:getX(), closestSq:getY(), closestSq:getZ())
				return closestSq
			end

			print("No vehicle zones found, fallback to player square")
			return square
	end
end

function Vanvival_VehicleSpawnHelper.findTrailerSquare(square, vehicleDir, minDistance, maxDistance)
	maxDistance = maxDistance or 8
	minDistance = minDistance or 4
	local x, y, z = square:getX(), square:getY(), square:getZ()

	local dx, dy = 0, 0
	if vehicleDir == IsoDirections.N then dy = 1
    elseif vehicleDir == IsoDirections.S then dy = -1
    elseif vehicleDir == IsoDirections.E then dx = -1
    elseif vehicleDir == IsoDirections.W then dx = 1
    end

	local cell = getCell()
	for i = minDistance, maxDistance do
        local checkSquare = cell:getGridSquare(x + dx * i, y + dy * i, z)
        if checkSquare and checkSquare:isOutside() and checkSquare:isFree(false) and not checkSquare:isVehicleIntersecting() then
            print("Found trailer square at:", checkSquare:getX(), checkSquare:getY(), checkSquare:getZ())
            return checkSquare
        end
    end
	print("No free trailer square found, using vehicle square")
    return square
end


-- Function to clear Custom Traits vehicle inventory
function Vanvival_VehicleSpawnHelper.ClearVehicleInventory(vehicle)
	local partCount = vehicle:getPartCount()

	for i = 0, partCount -1 do
		local part = vehicle:getPartByIndex(i)
		if part then
			local container = part:getItemContainer()
			if container then
				container:clear()
			end
		end
	end
end

return Vanvival_VehicleSpawnHelper